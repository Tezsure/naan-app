import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/data/services/create_profile_service/create_profile_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../common_widgets/back_button.dart';
import '../../../../../common_widgets/solid_button.dart';

class AddNewAccountBottomSheet extends StatelessWidget {
  AddNewAccountBottomSheet({Key? key}) : super(key: key);

  final controller = Get.find<AccountsWidgetController>();
  @override
  Widget build(BuildContext context) {
    controller.initAddAccount();
    return Obx(
      () => controller.isCreatingNewAccount.value
          ? Container(
              height: 1.height,
              width: 1.width,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 0.8.height,
                    width: 1.width,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: LottieBuilder.asset(
                      'assets/create_wallet/lottie/wallet_success.json',
                      fit: BoxFit.contain,
                      height: 0.5.height,
                      width: 0.5.width,
                      frameRate: FrameRate(60),
                    ),
                  ),
                ],
              ),
            )
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: DraggableScrollableSheet(
                  initialChildSize: 0.95,
                  minChildSize: 0.9,
                  maxChildSize: 0.95,
                  builder: (context, scrollController) {
                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.transparent,
                      body: Container(
                        color: Colors.black,
                        width: 1.width,
                        height: 1.height,
                        padding: EdgeInsets.symmetric(horizontal: 32.aR),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            0.01.vspace,
                            Center(
                              child: Container(
                                height: 5.aR,
                                width: 36.aR,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorConst.NeutralVariant.shade60
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                            0.01.vspace,
                            backButton(),
                            0.03.vspace,
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Name your account",
                                  style: titleLarge.copyWith(fontSize: 22.aR)),
                            ),
                            0.05.vspace,
                            Obx(
                              () => Center(
                                child: Container(
                                  height: 120.aR,
                                  width: 120.aR,
                                  alignment: Alignment.bottomRight,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: controller.currentSelectedType ==
                                              AccountProfileImageType.assets
                                          ? AssetImage(controller
                                              .selectedImagePath.value)
                                          : FileImage(
                                              File(
                                                controller
                                                    .selectedImagePath.value,
                                              ),
                                            ) as ImageProvider,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                        changePhotoBottomSheet(),
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 180),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 150),
                                        barrierColor:
                                            Colors.white.withOpacity(0.01),
                                        isScrollControlled: true,
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 20.aR,
                                      backgroundColor: Colors.white,
                                      child: SvgPicture.asset(
                                        "${PathConst.SVG}add_photo.svg",
                                        fit: BoxFit.contain,
                                        height: 20.aR,
                                        color: ColorConst.Primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            0.038.vspace,
                            NaanTextfield(
                              height: 52.aR,
                              onTextChange: (e) {
                                controller.phrase.value = e;
                              },
                              hint: "Account Name",
                              controller: controller.accountNameController,
                            ),
                            const Spacer(),
                            Obx(() => SolidButton(
                                  primaryColor: controller.phrase.isNotEmpty
                                      ? ColorConst.Primary
                                      : const Color(0xFF1E1C1F),
                                  height: 52.aR,
                                  onPressed: controller.phrase.isEmpty
                                      ? null
                                      : () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          controller.isCreatingNewAccount
                                              .value = true;
                                          controller.createNewWallet();
                                        },
                                  rowWidget: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "${PathConst.SVG}check.svg",
                                        color: Colors.white,
                                        height: 16.aR,
                                      ),
                                      0.015.hspace,
                                      Text(
                                        "Start using Naan",
                                        style: titleSmall.copyWith(
                                            fontSize: 14.aR,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )),
                            0.05.vspace
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  Widget changePhotoBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        width: 1.width,
        height: 296,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            0.005.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            0.03.vspace,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var imagePath = await CreateProfileService()
                          .pickANewImageFromGallery();
                      if (imagePath.isNotEmpty) {
                        controller.currentSelectedType =
                            AccountProfileImageType.file;
                        controller.selectedImagePath.value = imagePath;
                        Get.back();
                        Get.back();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 51,
                      alignment: Alignment.center,
                      child: Text(
                        "Choose from Library",
                        style: labelMedium,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xff4a454e),
                    height: 1,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Get.bottomSheet(avatarPicker(),
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 180),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 150),
                          isScrollControlled: true);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 51,
                      alignment: Alignment.center,
                      child: Text(
                        "Pick an avatar",
                        style: labelMedium,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xff4a454e),
                    height: 1,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.currentSelectedType =
                          AccountProfileImageType.assets;
                      controller.selectedImagePath.value =
                          ServiceConfig.allAssetsProfileImages[0];
                      Get.back();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 51,
                      alignment: Alignment.center,
                      child: Text(
                        "Remove photo",
                        style:
                            labelMedium.apply(color: ColorConst.Error.shade60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            0.016.vspace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: Get.back,
                child: Container(
                  height: 51,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: Text(
                    "Cancel",
                    style: labelMedium.apply(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget avatarPicker() {
    return Container(
      color: Colors.black,
      width: 1.width,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          0.04.vspace,
          Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: Get.back,
                child: SvgPicture.asset(
                  "${PathConst.SVG}arrow_back.svg",
                  fit: BoxFit.scaleDown,
                ),
              )),
          0.05.vspace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Pick an Avatar", style: titleLarge),
          ),
          0.05.vspace,
          Obx(
            () => Container(
              height: 0.3.width,
              width: 0.3.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: controller.currentSelectedType ==
                          AccountProfileImageType.assets
                      ? AssetImage(controller.selectedImagePath.value)
                      : FileImage(
                          File(
                            controller.selectedImagePath.value,
                          ),
                        ) as ImageProvider,
                ),
              ),
            ),
          ),
          0.05.vspace,
          Expanded(
            child: GridView.count(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              crossAxisCount: 4,
              mainAxisSpacing: 0.06.width,
              crossAxisSpacing: 0.06.width,
              children: List.generate(
                ServiceConfig.allAssetsProfileImages.length,
                (index) => GestureDetector(
                  onTap: () {
                    controller.currentSelectedType =
                        AccountProfileImageType.assets;
                    controller.selectedImagePath.value =
                        ServiceConfig.allAssetsProfileImages[index];
                  },
                  child: CircleAvatar(
                    radius: 0.08.width,
                    child: Image.asset(
                      ServiceConfig.allAssetsProfileImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.05.width),
            child: SolidButton(
              onPressed: () {
                Get
                  ..back()
                  ..back();
              },
              child: Text(
                "Confirm",
                style: titleSmall.apply(color: ColorConst.Primary.shade95),
              ),
            ),
          ),
          0.05.vspace
        ],
      ),
    );
  }
}
