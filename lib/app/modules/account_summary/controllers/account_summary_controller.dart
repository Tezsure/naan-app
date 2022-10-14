import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';

import '../../../data/services/data_handler_service/data_handler_service.dart';
import '../../../data/services/service_models/account_model.dart';
import '../../../data/services/service_models/nft_token_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';

class AccountSummaryController extends GetxController {
  final HomePageController homePageController = Get.find<HomePageController>();
  Rx<ScrollController> paginationController = ScrollController().obs;
  RxBool isAccountEditable = false.obs; // To edit account selector
  RxBool isEditable = false.obs; // for token edit mode
  RxBool expandTokenList =
      false.obs; // false = show 3 tokens, true = show all tokens
  RxBool isAccountDelegated =
      false.obs; // To check if current account is delegated
  RxMap<String, List<NftTokenModel>> userNfts =
      <String, List<NftTokenModel>>{}.obs; // List of user nfts
  RxBool isCollectibleListExpanded =
      false.obs; // false = show 3 collectibles, true = show all collectibles

  Rx<AccountModel> userAccount = AccountModel(isNaanAccount: true).obs;
  RxDouble xtzPrice = 0.0.obs;
  RxList<AccountTokenModel> userTokens = <AccountTokenModel>[].obs;
  RxList<TxHistoryModel> userTransactionHistory = <TxHistoryModel>[].obs;

  void changeName(String name) {
    userAccount.value.name = name;
    // UserStorageService().updateAccount(userAccount.value);
  }

  @override
  void onInit() {
    userAccount.value = Get.arguments as AccountModel;
    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
    });
    fetchAllTokens();
    fetchAllNfts();
    super.onInit();
  }

  @override
  void onClose() {
    paginationController.value.dispose();
    super.onClose();
  }

  void editAccount() {
    isAccountEditable.value = !isAccountEditable.value;
  }

  Future<void> userTransactionLoader() async {
    paginationController.value.removeListener(() {});
    userTransactionHistory.value = await fetchUserTransactionsHistory();
    paginationController.value.addListener(() async {
      if (paginationController.value.position.pixels ==
          paginationController.value.position.maxScrollExtent) {
        userTransactionHistory.addAll(await fetchUserTransactionsHistory(
            lastId: userTransactionHistory.last.id.toString()));
      }
    });
  }

  /// Fetches user account transaction history
  Future<List<TxHistoryModel>> fetchUserTransactionsHistory(
          {String? lastId, int? limit}) async =>
      await UserStorageService().getAccountTransactionHistory(
          accountAddress: userAccount.value.publicKeyHash!,
          lastId: lastId,
          limit: limit);

  /// Fetches the user account NFTs
  Future<void> fetchAllNfts() async {
    userNfts.clear();
    UserStorageService()
        .getUserNfts(userAddress: userAccount.value.publicKeyHash!)
        .then((nftList) {
      for (int i = 0; i < nftList.length; i++) {
        userNfts[nftList[i].fa!.contract!] =
            (userNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
      }
    });
  }

  void onPinToken() {
    // Move the selected indexes on top of the list when pin is clicked
    userTokens
      ..where((token) => token.isSelected && !token.isHidden)
          .toList()
          .forEach((element) {
        element.isPinned = true;
        userTokens.remove(element);
        userTokens.insert(0, element);
      })
      ..refresh();
    isEditable.value = false;
    expandTokenList.value = false;
    _updateUserTokenList();
  }

  Future<void> fetchAllTokens() async {
    userTokens.clear();
    userTokens.add(
      AccountTokenModel(
        name: "Tezos",
        balance: userAccount.value.accountDataModel!.xtzBalance!,
        contractAddress: "xtz",
        symbol: "Tezos",
        currentPrice: xtzPrice.value,
        tokenId: "0",
        decimals: 6,
        iconUrl: "assets/tezos_logo.png",
      ),
    );
    userTokens.addAll(await UserStorageService()
        .getUserTokens(userAddress: userAccount.value.publicKeyHash!));
  }

  void onHideToken() {
    // Move the tokens to the end of the list when hide is clicked
    userTokens
      ..where((token) => token.isSelected && !token.isPinned)
          .toList()
          .forEach((element) {
        element.isHidden = true;
        userTokens.remove(element);
        userTokens.add(element);
      })
      ..refresh();
    isEditable.value = false;
    expandTokenList.value = false;
    _updateUserTokenList();
  }

  Future<void> _updateUserTokenList() async {
    await UserStorageService()
        .updateUserTokens(
          accountTokenList: userTokens,
          userAddress: userAccount.value.publicKeyHash!,
        )
        .whenComplete(() async => userTokens.value = await UserStorageService()
            .getUserTokens(userAddress: userAccount.value.publicKeyHash!));
  }
}
