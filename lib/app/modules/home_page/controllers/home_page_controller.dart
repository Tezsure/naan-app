// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/account_selector.dart';
import 'package:naan_wallet/app/modules/backup_wallet_page/views/backup_wallet_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/scanQR/scan_qr.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/styles/styles.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../../common_widgets/solid_button.dart';

import 'package:permission_handler/permission_handler.dart';

import '../widgets/scanQR/permission_sheet.dart';

class HomePageController extends GetxController with WidgetsBindingObserver {
  // RxBool showBottomSheet = false.obs;
  RxInt selectedIndex = 0.obs;

  // Liquidity Baking
  RxBool isEnabled = false.obs; // To animate LB Button
  final Duration animationDuration =
      const Duration(milliseconds: 100); // Toggle LB Button Animation Duration
  RxDouble sliderValue = 0.0.obs;

  RxDouble xtzPrice = 0.0.obs;
  RxDouble dayChange = 0.0.obs;

  RxList<AccountModel> userAccounts = <AccountModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    Get.put(BeaconService(), permanent: true);
    DataHandlerService()
        .renderService
        .accountUpdater
        .registerCallback((accounts) async {
      // print("accountUpdater".toUpperCase());
      // print("${userAccounts.value.hashCode == accounts.hashCode}");
      userAccounts.value = [...(accounts ?? [])];
      userAccounts.sort((a, b) =>
          b.importedAt!.millisecondsSinceEpoch -
          a.importedAt!.millisecondsSinceEpoch);
      Future.delayed(
        Duration(milliseconds: 500),
      ).then((value) {
        try {
          Get.put(AccountsWidgetController()).onPageChanged(0);
          changeSelectedAccount(0);
        } catch (e) {
          log(e.toString());
        }
      });

      try {
        if (userAccounts.where((p0) => !p0.isWatchOnly).isNotEmpty) {
          Future.delayed(const Duration(seconds: 1), () async {
            userAccounts[0].delegatedBakerAddress =
                await Get.put(DelegateWidgetController())
                    .getCurrentBakerAddress(userAccounts[0].publicKeyHash!);
            print("baker address :${userAccounts[0].delegatedBakerAddress}");
          });
        }
      } catch (e) {
        log(e.toString());
      }
    });
    // .registerVariable(userAccounts);

    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
      print("xtzPrice: $value");
      //update();
    });

    DataHandlerService()
        .renderService
        .dayChangeUpdater
        .registerCallback((value) {
      dayChange.value = value;
      print("dayChange: $value");
      //update();
    });

    // DataHandlerService().renderService.accountNft.registerCallback((data) {
    //   print("Nft data");
    //   print(jsonEncode(data));
    // });
  }

  @override
  void onReady() async {
    super.onReady();

    if (Get.arguments != null &&
        Get.arguments.length == 2 &&
        Get.arguments[1].toString().isNotEmpty) {
      showBackUpWalletBottomSheet(Get.arguments[1].toString());
    }
  }

  void onTapLiquidityBaking() {
    isEnabled.value = !isEnabled.value;
  }

  void changeSelectedAccount(int index) async {
    print("On PAGECHANGED");
    // Get.find<AccountsWidgetController>().onPageChanged(index);

    if (userAccounts.length > index) {
      selectedIndex.value = index;
      userAccounts[index].delegatedBakerAddress =
          await Get.put(DelegateWidgetController())
              .getCurrentBakerAddress(userAccounts[index].publicKeyHash!);
      print("baker address :${userAccounts[index].delegatedBakerAddress}");
    }
  }

  void onSliderChange(double value) {
    sliderValue.value = value;
  }

  void showBackUpWalletBottomSheet(String seedPhrase) {
    Get.bottomSheet(
      BackupWalletBottomSheet(seedPhrase: seedPhrase),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      enableDrag: true,
      isDismissible: true,
      ignoreSafeArea: false,
    );
  }

  Future<void> openScanner() async {
    if (userAccounts[selectedIndex.value].isWatchOnly) {
      return Get.bottomSheet(
        AccountSelectorSheet(
          onNext: () {
            Get.back();
            openScanner();
          },
        ),
        isScrollControlled: true,
        enterBottomSheetDuration: const Duration(milliseconds: 180),
        exitBottomSheetDuration: const Duration(milliseconds: 150),
      );
    }
    await Permission.camera.request();
    final status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      Get.bottomSheet(const CameraPermissionHandler(),
          isScrollControlled: true);

      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      HapticFeedback.heavyImpact();
      Get.bottomSheet(const ScanQrView(),
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
          isScrollControlled: true);
    }
  } // void onIndicatorTapped(int index) => selectedIndex.value = index;
}

class BackupWalletBottomSheet extends StatelessWidget {
  final String seedPhrase;
  const BackupWalletBottomSheet({
    Key? key,
    required this.seedPhrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      // gradientStartingOpacity: 1,
      // blurRadius: 5,
      height: 350.arP,
      bottomSheetWidgets: [
        0.03.vspace,
        Text(
          'Backup your account',
          style: titleLarge,
        ),
        0.012.vspace,
        Text(
          'With no backup. Losing your device will result in the loss of access forever. The only way to guard against losses is to backup your wallet.',
          textAlign: TextAlign.start,
          style: bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
        ),
        .03.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SolidButton(
              width: 1.width,
              textColor: Colors.white,
              title: "Backup wallet ( ~1 min )",
              onPressed: () {
                Get.back();
                NaanAnalytics.logEvent(NaanAnalyticsEvents.BACKUP_FROM_HOME);
                Get.bottomSheet(
                    BackupWalletView(
                      seedPhrase: seedPhrase,
                    ),
                    barrierColor: Colors.transparent,
                    enterBottomSheetDuration: const Duration(milliseconds: 180),
                    exitBottomSheetDuration: const Duration(milliseconds: 150),
                    isScrollControlled: true);
              }),
        ),
        0.012.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SolidButton(
              borderWidth: 1,
              borderColor: ColorConst.Primary.shade80,
              primaryColor: Colors.transparent,
              width: 1.width,
              textColor: ColorConst.Primary.shade80,
              title: "I will risk it",
              onPressed: () {
                NaanAnalytics.logEvent(NaanAnalyticsEvents.BACKUP_SKIP);

                Get.back();
              }),
        ),
        BottomButtonPadding()
      ],
    );
  }
}
