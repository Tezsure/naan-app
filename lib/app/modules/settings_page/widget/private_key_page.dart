import 'package:naan_wallet/app/modules/settings_page/widget/backup_page.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/backup_wallet_page/views/widgets/phrase_container.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'package:naan_wallet/app/data/mock/mock_data.dart';

class PrivateKeyPage extends StatelessWidget {
  const PrivateKeyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: true,
      child: Scaffold(
        body: Container(
          height: 1.height,
          width: 1.width,
          padding: const EdgeInsets.only(top: 30),
          decoration:
              const BoxDecoration(gradient: GradConst.GradientBackground),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backButton(),
                    InfoButton(
                      onPressed: () => Get.bottomSheet(
                        infoBottomSheet(),
                        enableDrag: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        barrierColor: const Color.fromARGB(09, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
              0.087.vspace,
              Text(
                'Your Private Key',
                style: titleLarge,
              ),
              0.030.vspace,
              Text(
                'Your private key can be used to\naccess all of your funds so do not\nshare with anyone',
                textAlign: TextAlign.center,
                style: bodyLarge.copyWith(
                    color: ColorConst.NeutralVariant.shade60),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 34),
                padding: EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorConst.NeutralVariant.shade60, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "edskS2ZE3Xg2gNUG5SksdtJaGt3VtGo8R7C7zQ5zG7xGW9Z9JscEe1A2uhwVGfqqw9t7d3cHjvmnSMU41t37ppRAYnZJgKUjyt",
                  style: bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              CopyButton(
                isCopied: false, //controller.phraseCopy.value,
                //   onPressed: () => controller.paste().whenComplete(() =>
                //       ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //               content:
                //                   Text('Copied to your clipboard !')))),
                // )
                onPressed: () {},
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'This screen will auto close in ',
                    textAlign: TextAlign.center,
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                  Text(
                    '30 seconds',
                    textAlign: TextAlign.center,
                    style: labelSmall,
                  )
                ],
              ),
              0.075.vspace
            ],
          ),
        ),
      ),
    );
  }

  Widget infoBottomSheet() {
    return NaanBottomSheet(
        blurRadius: 5,
        gradientStartingOpacity: 1,
        isDraggableBottomSheet: true,
        title: 'Introduction to crypto wallet',
        draggableListBuilder: (_, index) {
          return RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: '${MockData.walletInfo.keys.elementAt(index)}\n',
                style: bodyMedium,
                children: [
                  TextSpan(
                    text: "\n${MockData.walletInfo.values.elementAt(index)}\n",
                    style: bodySmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60,
                    ),
                  )
                ],
              ));
        });
  }
}