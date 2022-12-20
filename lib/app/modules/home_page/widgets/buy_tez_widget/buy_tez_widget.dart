import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/account_selector.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/widgets/account_selector/account_selector.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';

class BuyTezWidget extends StatelessWidget {
  const BuyTezWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.put(AccountSummaryController());
        HomePageController home = Get.find<HomePageController>();
/*         Get.bottomSheet(
          AccountSelectorSheet(
            onNext: () {
              HomePageController home = Get.find<HomePageController>();

              String url =
                  "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";

              print(url);
              Get.bottomSheet(
                const DappBrowserView(),
                barrierColor: Colors.white.withOpacity(0.09),
                settings: RouteSettings(
                  arguments: url,
                ),
                isScrollControlled: true,
              );
            },
          ),
          isScrollControlled: true,
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
        ); */
        Get.bottomSheet(
          AccountSwitch(title: "Buy Tez",subtitle:  'This module will be powered by wert.io and you will be using wert’s interface.',
            onNext: () {
              String url =
                  "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";
              Get.bottomSheet(
                const DappBrowserView(),
                barrierColor: Colors.white.withOpacity(0.09),
                settings: RouteSettings(
                  arguments: url,
                ),
                isScrollControlled: true,
              );
            },
          ),
          isScrollControlled: true,
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
        );
      },
      child: Container(
        height: 0.405.width,
        width: 0.405.width,
        margin: EdgeInsets.only(left: 24.sp),
        decoration: BoxDecoration(
          gradient: appleYellow,
          borderRadius: BorderRadius.circular(22.sp),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset("${PathConst.HOME_PAGE.SVG}buy_tez.svg"),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Buy Tez",
                        style: headlineSmall.copyWith(fontSize: 20.sp)),
                    Text(
                      "with credit card",
                      style: bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
