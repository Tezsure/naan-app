import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/backup_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../common_widgets/info_bottom_sheet.dart';
import 'private_key_page.dart';
import 'secret_phrase_page.dart';

class SelectToRevealKeyBottomSheet extends StatefulWidget {
  final AccountModel accountModel;
  const SelectToRevealKeyBottomSheet({super.key, required this.accountModel});

  @override
  State<SelectToRevealKeyBottomSheet> createState() => _SelectToRevealKeyBottomSheetState();
}

class _SelectToRevealKeyBottomSheetState extends State<SelectToRevealKeyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      isScrollControlled: true,
      blurRadius: 5,
      height: 0.9.height,
      bottomSheetHorizontalPadding: 24,
      bottomSheetWidgets: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(),
            InfoButton(
                onPressed: () => Get.bottomSheet(
                      InfoBottomSheet(),
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 180),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 150),
                      enableDrag: true,
                      isDismissible: true,
                      isScrollControlled: true,
                      barrierColor: const Color.fromARGB(09, 255, 255, 255),
                    )),
          ],
        ),
        0.17.arP.vspace,
        Center(
          child: SvgPicture.asset(
            "${PathConst.SETTINGS_PAGE.SVG}backup_success.svg",
            color: ColorConst.Primary,
            height: 90.arP,
          ),
        ),
        0.048.arP.vspace,
        Center(
          child: Text(
            "Your wallet is backed up",
            style: titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        0.012.arP.vspace,
        Center(
          child: Text(
            "Dont’t risk your money! Backup your\nwallet so you can recover it if you lose\nthis device.",
            style: bodySmall.copyWith(color: ColorConst.textGrey1),
            textAlign: TextAlign.center,
          ),
        ),
        0.04.vspace,
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              revealOptionMethod(
                  icon: '${PathConst.SETTINGS_PAGE}svg/secret_phrase.svg',
                  child: Text(
                    "View secret phrase",
                    style: labelMedium,
                  ),
                  onTap: () async {
                    if (!(await AuthService().verifyBiometricOrPassCode())) {
                      return;
                    }

                    // controller.timer;
                    final controller = Get.put(BackupPageController());
                    Get.bottomSheet(
                            SecretPhrasePage(
                              pkHash: widget.accountModel.publicKeyHash!,
                            ),
                            barrierColor: Colors.transparent,
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 180),
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 150),
                            isScrollControlled: true)
                        .then((_) => controller.timer.cancel());
                  }),
              0.02.vspace,
              revealOptionMethod(
                  icon: '${PathConst.SETTINGS_PAGE}svg/key.svg',
                  child: Text(
                    "View private key",
                    style: labelMedium,
                  ),
                  onTap: () async {
                    if (!(await AuthService().verifyBiometricOrPassCode())) {
                      return;
                    }

                    // controller.timer;
                    final controller = Get.put(BackupPageController());
                    Get.bottomSheet(
                            PrivateKeyPage(
                              pkh: widget.accountModel.publicKeyHash!,
                            ),
                            barrierColor: Colors.transparent,
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 180),
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 150),
                            isScrollControlled: true)
                        .then((_) => controller.timer.cancel());
                  }),
              // revealOptionMethod(
              //     child: Text(
              //       "Private Key",
              //       style: labelMedium,
              //     ),
              //     onTap: () {
              //       controller.timer;
              //       Get.to(() => PrivateKeyPage(
              //             pkh: accountModel.publicKeyHash!,
              //           ))?.whenComplete(() => controller.timer.cancel());
              //     }),
            ],
          ),
        ),
      ],
    );
  }

  Widget revealOptionMethod(
      {Widget? child, GestureTapCallback? onTap, String? icon}) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        width: 0.65.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 16.arP, horizontal: 24.arP),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon ?? "",
              fit: BoxFit.fill,
              height: 25.arP,
            ),
            SizedBox(
              width: 15.arP,
            ),
            Center(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
