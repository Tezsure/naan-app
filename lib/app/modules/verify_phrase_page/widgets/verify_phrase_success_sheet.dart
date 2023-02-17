import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:share_plus/share_plus.dart';

class VerifyPhraseSuccessSheet extends StatelessWidget {
  const VerifyPhraseSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    AppConstant.hapticFeedback();
    NaanAnalytics.logEvent(NaanAnalyticsEvents.BACKUP_SUCCESSFUL);
    return NaanBottomSheet(
        bottomSheetHorizontalPadding: 32.arP,
        height: 0.37.height,
        bottomSheetWidgets: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.035.vspace,
              LottieBuilder.asset(
                '${PathConst.SEND_PAGE}lottie/success_primary.json',
                height: 80.arP,
                width: 80.arP,
                repeat: false,
              ),
              0.0175.vspace,
              Text(
                "Backup successful",
                style: titleLarge,
              ),
              0.006.vspace,
              Text(
                "Hope you have written the secret \nphrase safely",
                textAlign: TextAlign.center,
                style: labelSmall.copyWith(color: ColorConst.textGrey1),
              ),
              0.036.vspace,
              SolidButton(
                active: true,
                onPressed: () {
                  Get.back();
                },
                title: "Done",
              ),
              BottomButtonPadding()
            ],
          ),
        ]);
  }
}
