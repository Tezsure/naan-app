import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';

import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';

import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_account_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';

class BuyTezWidget extends StatelessWidget {
  BuyTezWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        Get.put(AccountSummaryController());
        HomePageController home = Get.find<HomePageController>();
        if (home.userAccounts
            .where((element) => element.isWatchOnly == false)
            .toList()
            .isEmpty) {
          CommonFunctions.bottomSheet(
            NoAccountsFoundBottomSheet(),
            // enterBottomSheetDuration: const Duration(milliseconds: 180),
            // exitBottomSheetDuration: const Duration(milliseconds: 150),
          );
          return;
        } else {
          CommonFunctions.bottomSheet(
            AccountSwitch(
              title: "Buy tez",
              subtitle:
                  'This module will be powered by wert.io and you will be using wert’s interface.',
              onNext: ({String senderAddress = ""}) async {
                NaanAnalytics.logEvent(NaanAnalyticsEvents.BUY_TEZ_CLICKED,
                    param: {
                      NaanAnalytics.address: home
                          .userAccounts[home.selectedIndex.value].publicKeyHash
                    });
                String url =
                    "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";
/*                 CommonFunctions.bottomSheet(
                  const DappBrowserView(),
                  fullscreen: true,
                  settings: RouteSettings(
                    arguments: url,
                  ),
                ); */
                print(url);
                Platform.isIOS
                    ? await launchUrl(Uri.parse(url),
                        mode: LaunchMode.inAppWebView)
                    : CommonFunctions.bottomSheet(
                        const DappBrowserView(),
                        fullscreen: true,
                        settings: RouteSettings(
                          arguments: url,
                        ),
                      );
              },
            ),
          );
        }
      },
      child: HomeWidgetFrame(
        child: Container(
          // height: AppConstant.homeWidgetDimension,
          // width: AppConstant.homeWidgetDimension,
          // margin: EdgeInsets.only(left: 24.arP),
          decoration: BoxDecoration(
            gradient: appleYellow,
            borderRadius: BorderRadius.circular(22.arP),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  "${PathConst.HOME_PAGE}buy_tez.png",
                  cacheHeight: 335,
                  cacheWidth: 335,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.arP),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Buy tez".tr,
                          style: headlineSmall.copyWith(fontSize: 20.arP)),
                      Text(
                        "with your card".tr,
                        style: bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
