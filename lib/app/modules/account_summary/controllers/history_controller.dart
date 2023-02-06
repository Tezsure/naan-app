import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/history_filter_controller.dart';
import 'package:naan_wallet/utils/utils.dart';

class HistoryController extends GetxController {
  final accountSummaryController = Get.find<AccountSummaryController>();
  RxList<TxHistoryModel> userTransactionHistory =
      <TxHistoryModel>[].obs; // List of user transactions
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  onLoad() async {
    try {
      Get.find<HistoryFilterController>().clear();
    } catch (e) {}
    userTransactionHistory.value = await fetchUserTransactionsHistory();
  }

  /// Fetches user account transaction history
  Future<List<TxHistoryModel>> fetchUserTransactionsHistory(
          {String? lastId, int? limit}) async =>
      await UserStorageService().getAccountTransactionHistory(
          accountAddress:
              accountSummaryController.selectedAccount.value.publicKeyHash!,
          lastId: lastId,
          limit: limit);
  @override
  void onClose() {
    // TODO: implement onClose
  }
}

extension TxChecker on TxHistoryModel {
  String get getName {
    if (sender?.address !=
        Get.find<AccountSummaryController>()
            .selectedAccount
            .value
            .publicKeyHash) {
      return sender?.alias ?? sender?.address?.tz1Short() ?? "";
    }
    if (newDelegate != null) {
      return newDelegate?.alias ?? newDelegate?.address?.tz1Short() ?? "";
    }
    if (prevDelegate != null) {
      return prevDelegate?.alias ?? prevDelegate?.address?.tz1Short() ?? "";
    }

    if (target != null) {
      return target?.alias ?? target?.address?.tz1Short() ?? "";
    }
      return "";

  }
}