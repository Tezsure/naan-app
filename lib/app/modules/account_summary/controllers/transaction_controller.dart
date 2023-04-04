import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/models/token_info.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';

import '../../../../utils/constants/path_const.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../../data/services/service_models/contact_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';
import 'history_filter_controller.dart';
import 'package:naan_wallet/utils/utils.dart';

class TransactionController extends GetxController {
  final accController = Get.find<AccountSummaryController>();

  RxList<TxHistoryModel> userTransactionHistory =
      <TxHistoryModel>[].obs; // List of user transactions
  RxBool isTransactionPopUpOpened = false.obs; // To show popup
  Rx<ScrollController> paginationController =
      ScrollController().obs; // For Transaction history lazy loading
  RxBool isFilterApplied = false.obs;
  Timer? searchDebounceTimer;
  Set<String> tokenTransactionID = <String>{};
  RxList<TokenInfo> filteredTransactionList = <TokenInfo>[].obs;

  @override
  void onInit() {
    updateSavedContacts();
    super.onInit();
  }

  @override
  void onClose() {
    paginationController.value.dispose();
    super.onClose();
  }

  RxBool isTransactionLoading = false.obs;
  List<TokenInfo> defaultTransactionList = <TokenInfo>[];
  static final Set<String> _tokenTransactionID = <String>{};

  /// Loades the user transaction history, and updates the UI after user taps on history tab
  Future<void> userTransactionLoader() async {
    defaultTransactionList.clear();
    _tokenTransactionID.clear();
    paginationController.value.removeListener(() {});
    userTransactionHistory.value = await fetchUserTransactionsHistory();
    isFilterApplied.value = false;
    if (Get.isRegistered<HistoryFilterController>()) {
      Get.find<HistoryFilterController>().clear();
    }
    defaultTransactionList.addAll(_sortTransaction(userTransactionHistory));
    // Lazy Loading
    paginationController.value.addListener(() async {
      if (paginationController.value.position.pixels ==
          paginationController.value.position.maxScrollExtent) {
        if (Get.isRegistered<HistoryFilterController>()) {
          if (noMoreResults.isFalse) {
            await loadFilteredTransaction();
          }
        } else {
          if (noMoreResults.isFalse) {
            await loadMoreTransaction();
          }
        }
      }
    });
  }

  RxList<TokenInfo> searchTransactionList = <TokenInfo>[].obs;
  Future<void> loadSearchResults(String searchName) async {
    var loadMoreTransaction = await fetchUserTransactionsHistory(
        lastId: searchTransactionList.last.token!.lastid.toString());
    searchTransactionList.addAll(_sortTransaction(loadMoreTransaction)
        .where(
            (element) => element.name.isCaseInsensitiveContainsAny(searchName))
        .toList());
  }

  Future<void> loadFilteredTransaction() async {
    var historyFilterController = Get.find<HistoryFilterController>();
    isTransactionLoading.value = true;

    var loadMoreTransaction = filteredTransactionList.isNotEmpty
        ? await fetchUserTransactionsHistory(
            lastId: filteredTransactionList.last.token!.lastid.toString())
        : <TxHistoryModel>[];
    loadMoreTransaction.isEmpty
        ? noMoreResults.value = true
        : noMoreResults.value = false;
    filteredTransactionList.addAll(historyFilterController.fetchFilteredList(
        nextHistoryList: _sortTransaction(loadMoreTransaction)));
    isTransactionLoading.value = false;
  }

  Future<void> loadMoreTransaction() async {
    isTransactionLoading.value = true;
    var loadMoreTransaction = await fetchUserTransactionsHistory(
        lastId: userTransactionHistory.last.lastid.toString());
    loadMoreTransaction.isEmpty
        ? noMoreResults.value = true
        : noMoreResults.value = false;
    userTransactionHistory.addAll(loadMoreTransaction);
    defaultTransactionList.addAll(_sortTransaction(loadMoreTransaction));
    isTransactionLoading.value = false;
  }

  RxBool noMoreResults = false.obs;

  List<TokenInfo> _sortTransaction(List<TxHistoryModel> transactionList) {
    List<TokenInfo> sortedTransactionList = <TokenInfo>[];
    late TokenInfo tokenInfo;
    String? isHashSame;
    for (int i = 0; i < transactionList.length; i++) {
      var tx = transactionList[i];
      tokenInfo = TokenInfo(
        isHashSame: isHashSame == null ? false : tx.hash!.contains(isHashSame),
        token: tx,
        timeStamp: tx.timestamp == null
            ? DateTime.now()
            : DateTime.parse(tx.timestamp!),
        isSent: tx.sender!.address!
            .contains(accController.selectedAccount.value.publicKeyHash!),
      );
      isHashSame = tx.hash!;
      // For tezos transaction
      if (tx.isTezosTransaction) {
        tokenInfo = tokenInfo.copyWith(
          token: tx,
          tokenSymbol: "tez",
          tokenAmount: tx.amount! / 1e6,
          dollarAmount: (tx.amount! / 1e6) * accController.xtzPrice.value,
        );
      }
      // For normal transaction
      else if (tx.isAnyTokenOrNFTTransaction) {
        if (tx.isFa2Token) {
          if (tx.isNft) {
            tokenInfo = tokenInfo.copyWith(
              isNft: true,
              address: tx.target!.address!,
              nftTokenId: tx.nftTokenId,
            );
          } else {
            TokenPriceModel token = tx.getFa2TokenName;
            String amount = tx.fa2TokenAmount;
            tokenInfo = tokenInfo.copyWith(
                name: token.name ?? token.tokenAddress?.tz1Short() ?? "",
                imageUrl:
                    token.thumbnailUri ?? "${PathConst.EMPTY_STATES}token.svg",
                tokenSymbol: token.symbol!,
                tokenAmount: double.parse(amount) / pow(10, token.decimals!),
                dollarAmount: double.parse(amount) /
                    pow(10, token.decimals!) *
                    accController.xtzPrice.value);
          }
        } else {
          if (tx.isFa1Token) {
            TokenPriceModel token = tx.getFa1TokenName;
            String amount = tx.fa1TokenAmount;
            tokenInfo = tokenInfo.copyWith(
                token: tx,
                name: token.name!,
                imageUrl: token.thumbnailUri!,
                tokenSymbol: token.symbol!,
                tokenAmount: double.parse(amount) / pow(10, token.decimals!),
                dollarAmount: double.parse(amount) /
                    pow(10, token.decimals!) *
                    accController.xtzPrice.value);
          } else {
            tokenInfo = tokenInfo.copyWith(skip: true);
          }
        }
      }
      // For delegation transaction
      else if (tx.type!.toLowerCase().contains("delegation")) {
        tokenInfo = tokenInfo.copyWith(
          isDelegated: true,
          token: tx,
          name: tx.newDelegate!.alias!,
          address: tx.newDelegate!.address!,
        );
      } else {
        tokenInfo = tokenInfo.copyWith(skip: true);
      }
      sortedTransactionList.addIf(
          !_tokenTransactionID.contains(tx.lastid.toString()), tokenInfo);
      _tokenTransactionID.add(tx.lastid.toString());
    }
    List<TokenInfo> temp = [];
    for (var i = 0; i < sortedTransactionList.length; i++) {
      if (sortedTransactionList[i].isHashSame ?? false) {
        temp.last = temp.last.copyWith(internalOperation: [
          ...temp.last.internalOperation,
          sortedTransactionList[i]
        ]);
      } else {
        temp.add(sortedTransactionList[i]);
      }
    }
    sortedTransactionList = [...temp].reversed.toList();
    return sortedTransactionList;
  }

  /// Fetches user account transaction history
  Future<List<TxHistoryModel>> fetchUserTransactionsHistory(
          {String? lastId, int? limit}) async =>
      await UserStorageService().getAccountTransactionHistory(
          accountAddress: accController.selectedAccount.value.publicKeyHash!,
          lastId: lastId,
          limit: limit);

  Future<void> searchTransactionHistory(String searchKey) async {
    searchTransactionList.value = defaultTransactionList
        .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchKey))
        .toList();
    while (searchTransactionList.length < 10 && noMoreResults.isFalse) {
      await loadMoreTransaction();
      searchTransactionList.value = defaultTransactionList
          .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchKey))
          .toList();
    }
    noMoreResults.value = false;
  }

  RxList<ContactModel> contacts = <ContactModel>[].obs;
  Rx<ContactModel?>? contact;

  Future<void> updateSavedContacts() async {
    contacts.value = await UserStorageService().getAllSavedContacts();
    if (Get.isRegistered<SendPageController>()) {
      Get.find<SendPageController>().contacts.value = contacts.value;
    }
  }

  ContactModel? getContact(String address) {
    return contacts.firstWhereOrNull((element) => element.address == address);
  }

  void onAddContact(String address, String name, String? imagePath) {
    contacts.add(ContactModel(
        name: name,
        address: address,
        imagePath: imagePath ??
            ServiceConfig.allAssetsProfileImages[Random().nextInt(
              ServiceConfig.allAssetsProfileImages.length - 1,
            )]));
  }
}

extension TransactionChecker on TxHistoryModel {
  bool get isTezosTransaction =>
      amount != null && amount! > 0 && parameter == null;
  bool get isAnyTokenOrNFTTransaction =>
      parameter != null && parameter?.entrypoint == "transfer";
  bool get isFa2Token {
    if (parameter!.value is Map) {
      return false;
    } else if (parameter!.value is List) {
      return true;
    } else if (parameter!.value is String) {
      var decodedString = jsonDecode(parameter!.value);
      if (decodedString is List) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool get isNft => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) => (p0.tokenAddress!.contains(target!.address!) &&
          p0.tokenId!.contains(parameter!.value is List
              ? parameter?.value[0]["txs"][0]["token_id"]
              : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])))
      .isEmpty;

  bool get isFa1Token => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) => (p0.tokenAddress!.contains(target!.address!)))
      .isNotEmpty;

  String get fa2TokenAmount => parameter?.value is List
      ? parameter?.value[0]["txs"][0]["amount"]
      : jsonDecode(parameter!.value)[0]["txs"][0]["amount"];

  String get nftTokenId {
    if (parameter?.value is String) {
      var decodedString = jsonDecode(parameter!.value);
      return decodedString is Map
          ? decodedString["txs"][0]["token_id"]
          : decodedString[0]["txs"][0]["token_id"];
    } else if (parameter?.value is Map) {
      return parameter?.value["txs"][0]["token_id"];
    } else if (parameter?.value is List) {
      return parameter?.value[0]["txs"][0]["token_id"];
    } else {
      return "";
    }
  }

  String get fa1TokenAmount {
    try {
      return parameter?.value is Map
          ? parameter!.value['value']
          : jsonDecode(parameter!.value)['value'];
    } catch (e) {
      return "0";
    }
  }

  AliasAddress get send {
    return getAddressAlias(sender!);
  }

  AliasAddress get reciever {
    print("hash: $hash");
    if (parameter != null &&
        parameter?.value is Map<String, List> &&
        parameter?.value?["txs"]?[0]?["to_"] != null) {
      return getAddressAlias(
          AliasAddress(address: parameter?.value?["txs"]?[0]?["to_"]));
    }
    if (target != null) return getAddressAlias(target!);
    return getAddressAlias(sender!);
  }

  AliasAddress getAddressAlias(AliasAddress address) {
    final homeController = Get.find<HomePageController>();
    final transactionController = Get.find<TransactionController>();
    if (homeController.userAccounts
        .any((element) => element.publicKeyHash!.contains(address.address!))) {
      final account = homeController.userAccounts.firstWhere(
          (element) => element.publicKeyHash!.contains(address.address!));
      return AliasAddress(address: account.publicKeyHash, alias: account.name);
    } else if (transactionController.contacts
        .any((element) => element.address.contains(address.address!))) {
      final contact = transactionController.contacts
          .firstWhere((element) => element.address.contains(address.address!));
      return AliasAddress(address: contact.address, alias: contact.name);
    }
    return address;
  }

  String get actionType {
    final homeController = Get.find<HomePageController>();

    if (newDelegate != null) {
      return "Delegated to ${newDelegate!.alias ?? newDelegate!.address!.tz1Short()}";
    }
    // if (homeController.userAccounts
    //     .any((element) => element.publicKeyHash!.contains(sender!.address!))) {
    //   return "Sent";
    // }
    // if (target != null &&
    //     homeController.userAccounts.any(
    //         (element) => element.publicKeyHash!.contains(target!.address!))) {
    //   return "Received";
    // }
    if (type == "transaction") {
      List<String> swapTypes = [
        "swap",
        "_to_",
        "xtzToTokenSwapInput",
        "tokenToXtzSwapInput",
        "tokenToTokenSwapInput"
      ];

      ///Check Swap
      if (parameter != null) {
        if ((swapTypes.any(
            (element) => parameter!.entrypoint?.contains(element) ?? false))) {
          return "Swapped";
        }
        if (parameter!.entrypoint == "offer") {
          return "Offer in ${target?.alias ?? target?.address?.tz1Short()} ";
        }
      }
    }
    if (homeController.userAccounts
        .any((element) => element.publicKeyHash!.contains(sender!.address!))) {
      return "Sent";
    }
    if (target != null &&
        homeController.userAccounts.any(
            (element) => element.publicKeyHash!.contains(target!.address!))) {
      return "Received";
    }
    if (target != null) {
      return target!.alias ?? "Contract interaction";
    }

    return type?.capitalizeFirst ?? "";
  }

  TokenPriceModel get getFa1TokenName => Get.find<AccountSummaryController>()
      .tokensList
      .firstWhere((p0) => (p0.tokenAddress!.contains(target!.address!)));

  TokenPriceModel get getFa2TokenName => Get.find<AccountSummaryController>()
      .tokensList
      .firstWhere((p0) => (p0.tokenAddress!.contains(target!.address!) &&
          p0.tokenId!.contains(parameter!.value is List
              ? parameter?.value[0]["txs"][0]["token_id"]
              : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])));
}

extension DateOnlyCompare on DateTime {
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}
