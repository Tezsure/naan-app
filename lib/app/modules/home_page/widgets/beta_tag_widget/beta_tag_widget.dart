import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/beta_tag_widget/beta_tag_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BetaTagWidget extends StatefulWidget {
  BetaTagWidget({Key? key}) : super(key: key);

  @override
  State<BetaTagWidget> createState() => _BetaTagWidgetState();
}

class _BetaTagWidgetState extends State<BetaTagWidget> {
  String version = "2.0.12";
  @override
  void initState() {
    PackageInfo.fromPlatform().then((packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      // version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        if (Platform.isAndroid) {
          CommonFunctions.bottomSheet(
            BetaTagSheet(),
          );
        }
      },
      child: HomeWidgetFrame(
        width: AppConstant.homeWidgetDimension,
        child: Container(
          color: ColorConst.darkGrey,
          width: AppConstant.homeWidgetDimension,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.arP, vertical: 16.arP),
                    child: _buildIcon()),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.arP),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Plenty wallet version".tr,
                          style: bodySmall.copyWith(
                              color: ColorConst.NeutralVariant.shade40)),
                      Text("$version ${Platform.isAndroid ? "(beta)" : ""}",
                          style: labelMedium),
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

  Widget _buildIcon() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(11.arP)),
      padding: EdgeInsets.all(AppConstant.homeWidgetDimension / 11),
      height: AppConstant.homeWidgetDimension / 2.5,
      width: AppConstant.homeWidgetDimension / 2.5,
      child: SvgPicture.asset("${PathConst.SVG}plenty_wallet_black.svg"),
    );
  }
}
