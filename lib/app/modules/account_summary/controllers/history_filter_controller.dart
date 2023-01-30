import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';

import '../models/token_info.dart';

class HistoryFilterController extends GetxController {
  final accountController = Get.find<TransactionController>();

  RxList<AssetType> assetType = AssetType.values.obs;
  RxList<TransactionType> transactionType = TransactionType.values.obs;
  Rx<DateType> dateType = DateType.none.obs;

  Rx<DateTime> fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  void setDate(DateType type, {DateTime? from, DateTime? to}) {
    dateType.value = type;
    if (type == DateType.today) {
      fromDate.value = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      toDate.value = DateTime.now();
    } else if (type == DateType.currentMonth) {
      fromDate.value = DateTime(
        DateTime.now().year,
        DateTime.now().month,
      );
      toDate.value = DateTime.now();
    } else if (type == DateType.last3Months) {
      fromDate.value = DateTime(
        DateTime.now().year,
        DateTime.now().month - 3,
      );
      toDate = DateTime.now().obs;
    } else {
      fromDate.value = from!;
      toDate.value = to!;
    }
  }

  Future<void> clear() async {
    accountController.filteredTransactionList.clear();
    assetType.value = [...AssetType.values];
    transactionType.value = [...TransactionType.values];
    dateType.value = DateType.none;
    accountController.noMoreResults.value = false;
    accountController.isFilterApplied.value = false;
  }

  List<TokenInfo> _applyFilter(List<TokenInfo> transactions) {
    DateTime time = DateTime.now();
    //print(transactions);
    switch (dateType.value) {
      case DateType.today:
        transactions = transactions
            .where((e) =>
                (DateTime(
                    e.timeStamp!.year, e.timeStamp!.month, e.timeStamp!.day)) ==
                (DateTime(time.year, time.month, time.day)))
            .toList();
        break;
      case DateType.currentMonth:
        transactions = transactions
            .where((e) =>
                (DateTime.now().month == e.timeStamp!.month) &&
                (DateTime.now().year == e.timeStamp!.year) &&
                (e.timeStamp!.day <= 31))
            .toList();
        break;
      case DateType.last3Months:
        transactions = transactions
            .where((e) =>
                (DateTime.now().month - 3 <= e.timeStamp!.month) &&
                (DateTime.now().year == e.timeStamp!.year) &&
                (e.timeStamp!.day <= 31))
            .toList();
        break;
      case DateType.customDate:
        transactions = transactions
            .where((e) =>
                (e.timeStamp!.isAfter(fromDate.value)) &&
                (e.timeStamp!.isBefore(toDate.value)))
            .toList();
        break;
      default:
        break;
    }
    List<TokenInfo> tempTransactions = [];
    if (transactionType
        .any((element) => element == TransactionType.delegation)) {
      tempTransactions = [
        ...tempTransactions,
        ...transactions.where((e) => e.isDelegated).toList()
      ];
    }
    if (transactionType.any((element) => element == TransactionType.receive)) {
      tempTransactions = [
        ...tempTransactions,
        ...transactions.where((e) => !e.isSent).toList()
      ];
    }
    if (transactionType.any((element) => element == TransactionType.send)) {
      tempTransactions = [
        ...tempTransactions,
        ...transactions.where((e) => e.isSent).toList()
      ];
    }
    if (assetType.length != 2) {
      if (assetType.any((element) => element == AssetType.token)) {
        tempTransactions = [
          ...tempTransactions.where((e) => !e.isNft).toList()
        ];
      }
      if (assetType.any((element) => element == AssetType.nft)) {
        tempTransactions = [...tempTransactions.where((e) => e.isNft).toList()];
      }
    }

    //print(tempTransactions);
    transactions = tempTransactions.toSet().toList();
    print(transactions);
    // switch (assetType.value) {
    //   case AssetType.token:
    //     transactions = transactions.where((e) => !e.isNft).toList();
    //     break;
    //   case AssetType.nft:
    //     transactions = transactions.where((e) => e.isNft).toList();
    //     break;
    //   default:
    // }
    return transactions;
  }

  void apply() async {
    accountController.isFilterApplied.value = true;
    accountController.filteredTransactionList.value =
        _applyFilter(accountController.defaultTransactionList);
    accountController.filteredTransactionList.refresh();
    Get.back();
  }

  List<TokenInfo> fetchFilteredList(
          {required List<TokenInfo> nextHistoryList}) =>
      _applyFilter(nextHistoryList);
}

enum AssetType {
  token,
  nft,
}

enum TransactionType {
  delegation,
  send,
  receive,
}

enum DateType { today, currentMonth, last3Months, customDate, none }
