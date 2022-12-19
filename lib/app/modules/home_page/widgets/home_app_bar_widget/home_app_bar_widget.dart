import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/views/settings_page_view.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class HomepageAppBar extends StatelessWidget {
  const HomepageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24, top: 26, bottom: 24, left: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Get.bottomSheet(
              //   TestNetworkBottomSheet(),
              // );
              Get.bottomSheet(const SettingsPageView(),
                  isScrollControlled: true);
            },
            child: Image.asset(
              "${PathConst.HOME_PAGE}menu.png",
              width: 24,
              height: 24,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.find<HomePageController>().openScanner();
            },
            child: Image.asset(
              "${PathConst.HOME_PAGE}scan.png",
              width: 42,
              height: 42,
            ),
          ),
        ],
      ),
    );
  }
}
