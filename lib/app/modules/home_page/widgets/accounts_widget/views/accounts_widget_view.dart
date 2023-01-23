import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/account_summary/views/account_summary_view.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/effects/expanding_dots_effects.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/effects/scrolling_dot_effect.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/smooth_page_indicator.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/receive_page/views/receive_page_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../controllers/accounts_widget_controller.dart';
import 'widget/add_account_widget.dart';

// ignore: must_be_immutable

class AccountsWidget extends StatefulWidget {
  const AccountsWidget({super.key});

  @override
  State<AccountsWidget> createState() => _AccountsWidgetState();
}

class _AccountsWidgetState extends State<AccountsWidget> {
  @override
  void initState() {
    controller.pageController = PageController(
      keepPage: true,
      viewportFraction: 1,
      initialPage: controller.currIndex.value,
    );
    // TODO: implement initState
    super.initState();
  }

  final HomePageController homePageController = Get.find<HomePageController>();
  final AccountsWidgetController controller =
      Get.put(AccountsWidgetController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(
          left: 22.arP,
          right: 10.arP,
        ),
        height: AppConstant.homeWidgetDimension,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: AppConstant.homeWidgetDimension,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    homePageController.userAccounts.isEmpty
                        ? Container(
                            width: double.infinity,
                            height: AppConstant.homeWidgetDimension,
                            padding: EdgeInsets.only(right: 8.arP),
                            child: const AddAccountWidget(),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff958E99).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(22.arP),
                            ),
                            width: double.infinity,
                            height: AppConstant.homeWidgetDimension,
                            child: Obx(() => PageView.builder(
                                padEnds: false,
                                itemCount: homePageController.userAccounts
                                        .where(
                                            (e) => e.isAccountHidden == false)
                                        .toList()
                                        .length +
                                    1,
                                controller: controller.pageController,
                                onPageChanged: (index) {
                                  controller.currIndex.value = index;
                                  homePageController
                                      .changeSelectedAccount(index);
                                  setState(() {});
                                },
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (_, index) {
                                  final scale =
                                      controller.currIndex.value == index
                                          ? 1.0
                                          : 0.8;

                                  return index ==
                                          homePageController.userAccounts
                                              .where((e) =>
                                                  e.isAccountHidden == false)
                                              .toList()
                                              .length
                                      ? TweenAnimationBuilder(
                                          tween: Tween<double>(
                                              begin: scale, end: scale),
                                          curve: Curves.easeIn,
                                          builder: (context, value, child) =>
                                              Transform.scale(
                                                scale: value,
                                                child: child,
                                              ),
                                          duration:
                                              const Duration(milliseconds: 350),
                                          child: const AddAccountWidget())
                                      : homePageController.userAccounts[index]
                                              .isAccountHidden!
                                          ? const SizedBox()
                                          : TweenAnimationBuilder(
                                              tween: Tween<double>(
                                                  begin: scale, end: scale),
                                              curve: Curves.easeIn,
                                              builder:
                                                  (context, value, child) =>
                                                      Transform.scale(
                                                        scale: value,
                                                        child: child,
                                                      ),
                                              duration: const Duration(
                                                  milliseconds: 350),
                                              child: accountContainer(
                                                  homePageController
                                                      .userAccounts[index],
                                                  index));
                                }))),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 8.arP,
            ),
            if (homePageController.userAccounts.isNotEmpty)
              SizedBox(
                width: 4.arP,
                child: AnimatedSmoothIndicator(
                    effect: ScrollingDotsEffect(
                      dotHeight: 4.arP,
                      dotWidth: 4.arP,
                      // expansionFactor: 1.01,
                      activeDotColor: Colors.white,
                      dotColor: ColorConst.darkGrey,
                    ),
                    axisDirection: Axis.vertical,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    activeIndex: controller.currIndex.value,
                    count: homePageController.userAccounts.length + 1),
              )
            else
              SizedBox(
                width: 4.arP,
              ),
          ],
        ),
      );
    });
  }

  Widget accountContainer(AccountModel model, int index) {
    return InkWell(
        onTap: () {
          homePageController.changeSelectedAccount(index);
          Get.bottomSheet(
            const AccountSummaryView(),
            enterBottomSheetDuration: const Duration(milliseconds: 180),
            exitBottomSheetDuration: const Duration(milliseconds: 150),
            settings: RouteSettings(arguments: model),
            isScrollControlled: true,
          );
        },
        child: Stack(
          children: [
            Container(
              width: 1.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22), gradient: accountBg),
            ),
            Padding(
              padding: EdgeInsets.all(0.04.width),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16.arP,
                        height: 16.arP,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(4.arP),
                          image: DecorationImage(
                            image: model.imageType ==
                                    AccountProfileImageType.assets
                                ? AssetImage(model.profileImage!)
                                : FileImage(
                                    File(model.profileImage!),
                                  ) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      0.020.hspace,
                      Text(
                        model.name!,
                        style: labelMedium,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: model.publicKeyHash));
                            Get.rawSnackbar(
                              maxWidth: 0.45.width,
                              backgroundColor: Colors.transparent,
                              snackPosition: SnackPosition.BOTTOM,
                              snackStyle: SnackStyle.FLOATING,
                              padding: const EdgeInsets.only(bottom: 60),
                              messageText: Container(
                                height: 36,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: ColorConst.Neutral.shade10,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Copied ${tz1Shortner(model.publicKeyHash!)}",
                                      style: labelSmall,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                tz1Shortner(model.publicKeyHash!),
                                style: bodySmall.copyWith(
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                              0.02.hspace,
                              SvgPicture.asset(
                                '${PathConst.SVG}copy.svg',
                                color: Colors.white.withOpacity(0.8),
                                fit: BoxFit.contain,
                                height: 14.aR,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  0.015.vspace,
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            (model.accountDataModel!.totalBalance! *
                                    homePageController.xtzPrice.value)
                                .roundUpDollar(),
                            style: headlineLarge,
                          ),
                        ),
                        if (model.isWatchOnly)
                          Container()
                        else
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.arP),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0.arP, vertical: 6.arP),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RawMaterialButton(
                                    constraints: BoxConstraints(
                                        minWidth: 48.arP, minHeight: 48.arP),
                                    elevation: 1,
                                    padding: const EdgeInsets.all(8),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    enableFeedback: true,
                                    onPressed: () => Get.bottomSheet(
                                        const SendPage(),
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 180),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 150),
                                        isScrollControlled: true,
                                        settings: RouteSettings(
                                          arguments: model,
                                        ),
                                        barrierColor:
                                            Colors.white.withOpacity(0.09)),
                                    fillColor: ColorConst.Primary.shade0,
                                    shape: const CircleBorder(
                                        side: BorderSide.none),
                                    child: Image.asset(
                                      "${PathConst.HOME_PAGE}send.png",
                                      width: 22.arP,
                                      height: 22.arP,
                                    ),
                                  ),
                                  0.036.hspace,
                                  RawMaterialButton(
                                    enableFeedback: true,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: const EdgeInsets.all(8),
                                    constraints: BoxConstraints(
                                        minWidth: 48.arP, minHeight: 48.arP),
                                    elevation: 1,
                                    onPressed: () => Get.bottomSheet(
                                        const ReceivePageView(),
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 180),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 150),
                                        isScrollControlled: true,
                                        settings: RouteSettings(
                                          arguments: model,
                                        ),
                                        barrierColor:
                                            Colors.white.withOpacity(0.09)),
                                    fillColor: ColorConst.Primary.shade0,
                                    shape: const CircleBorder(
                                        side: BorderSide.none),
                                    child: Image.asset(
                                      "${PathConst.HOME_PAGE}qr.png",
                                      width: 22.arP,
                                      height: 22.arP,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}


/* class AccountsWidget extends GetView<AccountsWidgetController> {
  AccountsWidget({super.key});

  final HomePageController homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    Get.put(AccountsWidgetController());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.arP),
      child: SizedBox(
        width: 1.width,
        height: 0.45.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => homePageController.userAccounts.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                          right: homePageController.userAccounts.isEmpty
                              ? 0.04.width
                              : 0),
                      child: const AddAccountWidget(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff958E99).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(22.arP),
                      ),
                      width: 1.width,
                      height: 0.45.width,
                      child: Obx(() => PageView.builder(
                          padEnds: false,
                          itemCount: homePageController.userAccounts
                                  .where((e) => e.isAccountHidden == false)
                                  .toList()
                                  .length +
                              1,
                          controller: PageController(
                            viewportFraction: 1,
                            initialPage: 0,
                          ),
                          onPageChanged: controller.onPageChanged,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (_, index) {
                            var scale =
                                controller.currIndex.value == index ? 1.0 : 0.8;
                            return index ==
                                    homePageController.userAccounts
                                        .where(
                                            (e) => e.isAccountHidden == false)
                                        .toList()
                                        .length
                                ? TweenAnimationBuilder(
                                    tween:
                                        Tween<double>(begin: scale, end: scale),
                                    curve: Curves.easeIn,
                                    builder: (context, value, child) =>
                                        Transform.scale(
                                          scale: value,
                                          child: child,
                                        ),
                                    duration: const Duration(milliseconds: 350),
                                    child: const AddAccountWidget())
                                : homePageController
                                        .userAccounts[index].isAccountHidden!
                                    ? const SizedBox()
                                    : TweenAnimationBuilder(
                                        tween: Tween<double>(
                                            begin: scale, end: scale),
                                        curve: Curves.easeIn,
                                        builder: (context, value, child) =>
                                            Transform.scale(
                                              scale: value,
                                              child: child,
                                            ),
                                        duration:
                                            const Duration(milliseconds: 350),
                                        child: accountContainer(
                                          homePageController
                                              .userAccounts[index],
                                        ));
                          }))),
            )
          ],
        ),
      ),
    );
  }

  Widget accountContainer(AccountModel model) {
    return InkWell(
        onTap: () => Get.bottomSheet(
              const AccountSummaryView(),
              settings: RouteSettings(arguments: model),
              isScrollControlled: true,
            ),
        child: Stack(
          children: [
            Container(
              width: 1.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22), gradient: accountBg),
            ),
            Padding(
              padding: EdgeInsets.all(0.04.width),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16.arP,
                        height: 16.arP,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(4.arP),
                          image: DecorationImage(
                            image: model.imageType ==
                                    AccountProfileImageType.assets
                                ? AssetImage(model.profileImage!)
                                : FileImage(
                                    File(model.profileImage!),
                                  ) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      0.020.hspace,
                      Text(
                        model.name!,
                        style: labelMedium,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              tz1Shortner(model.publicKeyHash!),
                              style: bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            0.02.hspace,
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: model.publicKeyHash));
                                Get.rawSnackbar(
                                  message: "Copied to clipboard",
                                  shouldIconPulse: true,
                                  snackPosition: SnackPosition.BOTTOM,
                                  maxWidth: 0.9.width,
                                  margin: const EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  duration: const Duration(milliseconds: 750),
                                );
                              },
                              child: Icon(
                                Icons.copy_outlined,
                                size: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  0.015.vspace,
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            "\$ ${(model.accountDataModel!.totalBalance! * homePageController.xtzPrice.value).toStringAsFixed(3)}",
                            style: headlineLarge,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.arP),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0.arP, vertical: 6.arP),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RawMaterialButton(
                                  constraints: BoxConstraints(
                                      minWidth: 48.arP, minHeight: 48.arP),
                                  elevation: 1,
                                  padding: const EdgeInsets.all(8),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  enableFeedback: true,
                                  onPressed: () => Get.bottomSheet(
                                      const SendPage(),
                                      isScrollControlled: true,
                                      settings: RouteSettings(
                                        arguments: model,
                                      ),
                                      barrierColor:
                                          Colors.white.withOpacity(0.09)),
                                  fillColor: ColorConst.Primary.shade0,
                                  shape:
                                      const CircleBorder(side: BorderSide.none),
                                  child: Image.asset(
                                    "${PathConst.HOME_PAGE}send.png",
                                    width: 24.arP,
                                    height: 24.arP,
                                  ),
                                ),
                                0.036.hspace,
                                RawMaterialButton(
                                  enableFeedback: true,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(8),
                                  constraints: BoxConstraints(
                                      minWidth: 48.arP, minHeight: 48.arP),
                                  elevation: 1,
                                  onPressed: () => Get.bottomSheet(
                                      const ReceivePageView(),
                                      isScrollControlled: true,
                                      settings: RouteSettings(
                                        arguments: model,
                                      ),
                                      barrierColor:
                                          Colors.white.withOpacity(0.09)),
                                  fillColor: ColorConst.Primary.shade0,
                                  shape:
                                      const CircleBorder(side: BorderSide.none),
                                  child: Image.asset(
                                    "${PathConst.HOME_PAGE}qr.png",
                                    width: 24.arP,
                                    height: 24.arP,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
} */
