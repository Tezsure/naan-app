import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/constants/path_const.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/create_profile_service/create_profile_service.dart';
import '../../../../data/services/enums/enums.dart';
import '../../../../data/services/service_config/service_config.dart';
import '../../../../data/services/service_models/account_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../common_widgets/bottom_sheet.dart';
import '../../../common_widgets/naan_textfield.dart';
import '../../../home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import '../../../send_page/views/pages/contact_page_view.dart';
import '../../../settings_page/controllers/settings_page_controller.dart';

class AccountSelectorSheet extends StatefulWidget {
  final AccountModel selectedAccount;
  const AccountSelectorSheet({
    super.key,
    required this.selectedAccount,
  });

  @override
  State<AccountSelectorSheet> createState() => _AccountSelectorSheetState();
}

class _AccountSelectorSheetState extends State<AccountSelectorSheet> {
  final AccountSummaryController _controller =
      Get.find<AccountSummaryController>();
  final SettingsPageController _settingsController =
      Get.put(SettingsPageController());

  late int selectedIndex;
  @override
  void initState() {
    _controller.isAccountEditable.value = false;
    selectedIndex = _controller.homePageController.userAccounts
        .indexOf(widget.selectedAccount);
    super.initState();
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: 0.8.height,
        width: 1.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.01.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              0.01.vspace,
              Center(
                child: Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
              0.01.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  0.15.hspace,
                  Text(
                    'Accounts',
                    style: titleMedium,
                  ),
                  Obx(() => TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent)),
                        onPressed: _controller.editAccount,
                        child: Text(
                          _controller.isAccountEditable.value ? "Done" : "Edit",
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary),
                        ),
                      )),
                ],
              ),
              0.01.vspace,
              Obx(
                () => Expanded(
                  child: ListView.builder(
                      itemCount:
                          _controller.homePageController.userAccounts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 2,
                            right: 2,
                            bottom: 4,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _controller.userAccount.value = _controller
                                        .homePageController.userAccounts[index];
                                    selectedIndex = index;
                                    _controller
                                      ..fetchAllTokens()
                                      ..fetchAllNfts()
                                      ..userTransactionLoader();
                                  });
                                },
                                dense: true,
                                leading: CustomImageWidget(
                                  imageType: _controller.homePageController
                                      .userAccounts[index].imageType!,
                                  imagePath: _controller.homePageController
                                      .userAccounts[index].profileImage!,
                                  imageRadius: 20,
                                ),
                                title: Text(
                                  '${_controller.homePageController.userAccounts[index].name}',
                                  style: bodySmall,
                                ),
                                subtitle: Text(
                                  '${_controller.homePageController.userAccounts[index].accountDataModel?.xtzBalance} tez',
                                  style: labelSmall.copyWith(
                                      color: ColorConst.NeutralVariant.shade60),
                                ),
                                trailing: Obx(() => Visibility(
                                      visible:
                                          _controller.isAccountEditable.isFalse,
                                      replacement: PopupMenuButton(
                                        enableFeedback: true,
                                        position: PopupMenuPosition.under,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        color: const Color(0xff421121),
                                        itemBuilder: (_) => <PopupMenuEntry>[
                                          CustomPopupMenuItem(
                                            height: 51,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 11),
                                            onTap: () {
                                              Get.bottomSheet(
                                                EditAccountBottomSheet(
                                                  accountIndex: index,
                                                ),
                                                isScrollControlled: true,
                                                barrierColor:
                                                    Colors.transparent,
                                              );
                                            },
                                            child: Text(
                                              "Edit Account",
                                              style: labelMedium,
                                            ),
                                          ),
                                          CustomPopupMenuDivider(
                                            height: 1,
                                            color: ColorConst.Neutral.shade50,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 11),
                                            thickness: 1,
                                          ),
                                          CustomPopupMenuItem(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 11),
                                            height: 51,
                                            onTap: () {
                                              Get.bottomSheet(
                                                removeAccountBottomSheet(index,
                                                    accountName: _controller
                                                        .homePageController
                                                        .userAccounts[index]
                                                        .name!, onPressed: () {
                                                  Get.back();
                                                  Get.back();
                                                  _controller.isAccountEditable
                                                      .value = false;
                                                  // Check whether deleted account was selected account and last in the list, then assign the second last element to current account
                                                  if (index == 0 &&
                                                      _controller
                                                              .homePageController
                                                              .userAccounts
                                                              .length ==
                                                          1) {
                                                    Get.rawSnackbar(
                                                      message:
                                                          "Can't delete only account",
                                                      shouldIconPulse: true,
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      maxWidth: 0.9.width,
                                                      margin:
                                                          const EdgeInsets.only(
                                                        bottom: 20,
                                                      ),
                                                      duration: const Duration(
                                                          milliseconds: 1000),
                                                    );
                                                  } else if (_controller
                                                          .homePageController
                                                          .userAccounts[index]
                                                          .publicKeyHash!
                                                          .contains(_controller
                                                              .userAccount
                                                              .value
                                                              .publicKeyHash!) &&
                                                      index ==
                                                          _controller
                                                                  .homePageController
                                                                  .userAccounts
                                                                  .length -
                                                              1) {
                                                    _controller.userAccount
                                                        .value = _controller
                                                            .homePageController
                                                            .userAccounts[
                                                        index - 1];
                                                    selectedIndex = index - 1;
                                                  } else if (index ==
                                                      _controller
                                                              .homePageController
                                                              .userAccounts
                                                              .length -
                                                          1) {
                                                    _controller.userAccount
                                                        .value = _controller
                                                            .homePageController
                                                            .userAccounts[
                                                        index - 1];
                                                    selectedIndex = index - 1;
                                                  } else {
                                                    _controller
                                                            .userAccount.value =
                                                        _controller
                                                            .homePageController
                                                            .userAccounts[index];
                                                    selectedIndex = index;
                                                  }
                                                  _settingsController
                                                      .removeAccount(index);
                                                  _controller
                                                    ..fetchAllTokens()
                                                    ..fetchAllNfts();
                                                }),
                                                barrierColor:
                                                    Colors.transparent,
                                              );
                                            },
                                            child: Text(
                                              "Delete account",
                                              style: labelMedium.apply(
                                                  color:
                                                      ColorConst.Error.shade60),
                                            ),
                                          ),
                                        ],
                                        child: const Icon(
                                          Icons.more_horiz,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: index == selectedIndex
                                          ? Container(
                                              height: 20.sp,
                                              width: 20.sp,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ColorConst.Primary),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 14.sp,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ))),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    Obx(() => InkWell(
                          onTap: (() {
                            if (_controller.isAccountEditable.isFalse) {
                              Get.bottomSheet(AddNewAccountBottomSheet(),
                                      barrierColor: Colors.transparent,
                                      isScrollControlled: true)
                                  .whenComplete(() {
                                Get.find<AccountsWidgetController>()
                                    .resetCreateNewWallet();
                              });
                            }
                          }),
                          child: Row(
                            children: [
                              Image.asset(
                                _controller.isAccountEditable.isFalse
                                    ? "${PathConst.EMPTY_STATES}plus.png"
                                    : "${PathConst.EMPTY_STATES}plus_faded.png",
                                scale: 1,
                              ),
                              0.02.hspace,
                              Text(
                                "Create a new account",
                                style: labelLarge.copyWith(
                                    color: _controller.isAccountEditable.isFalse
                                        ? ColorConst.Primary
                                        : ColorConst.NeutralVariant.shade60,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )),
                    0.01.vspace,
                    Obx(() => InkWell(
                          onTap: () {
                            if (_controller.isAccountEditable.isFalse) {
                              Get.toNamed(Routes.IMPORT_WALLET_PAGE);
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                _controller.isAccountEditable.isFalse
                                    ? "${PathConst.EMPTY_STATES}union.png"
                                    : "${PathConst.EMPTY_STATES}union_faded.png",
                                scale: 1,
                              ),
                              0.02.hspace,
                              Text(
                                "Add an existing account",
                                style: labelLarge.copyWith(
                                    color: _controller.isAccountEditable.isFalse
                                        ? ColorConst.Primary
                                        : ColorConst.NeutralVariant.shade60,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ))
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget removeAccountBottomSheet(int index,
    {required String accountName, required Function() onPressed}) {
  return NaanBottomSheet(
    bottomSheetHorizontalPadding: 32,
    blurRadius: 5,
    title: "Remove Account",
    titleStyle: titleLarge.copyWith(fontWeight: FontWeight.w700),
    titleAlignment: Alignment.center,
    height: 0.35.height,
    bottomSheetWidgets: [
      Center(
        child: Text(
          'Do you want to remove “$accountName”\nfrom your wallet?',
          style: labelMedium,
          textAlign: TextAlign.center,
        ),
      ),
      0.03.vspace,
      Column(
        children: [
          SolidButton(
            primaryColor: const Color(0xff1E1C1F),
            onPressed: onPressed,
            title: "Remove Account",
            textColor: ColorConst.Primary,
          ),
          0.01.vspace,
          SolidButton(
            primaryColor: const Color(0xff1E1C1F),
            onPressed: Get.back,
            title: "Cancel",
          ),
        ],
      ),
    ],
  );
}

class EditAccountBottomSheet extends StatefulWidget {
  final int accountIndex;
  const EditAccountBottomSheet({super.key, required this.accountIndex});

  @override
  State<EditAccountBottomSheet> createState() => _EditAccountBottomSheetState();
}

class _EditAccountBottomSheetState extends State<EditAccountBottomSheet> {
  final _controller = Get.find<SettingsPageController>();
  final AccountSummaryController _accountController =
      Get.find<AccountSummaryController>();
  FocusNode nameFocusNode = FocusNode();

  @override
  void initState() {
    nameFocusNode.requestFocus();
    _controller.accountNameController.text =
        _controller.homePageController.userAccounts[widget.accountIndex].name!;
    super.initState();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: 0.5.height,
      bottomSheetHorizontalPadding: 32,
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetWidgets: [editaccountUI()],
    );
  }

  Widget editaccountUI() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Builder(builder: (context) {
          return Column(children: [
            Container(
              height: 0.3.width,
              width: 0.3.width,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      _controller.showUpdatedProfilePhoto(widget.accountIndex),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(changePhotoBottomSheet(),
                          barrierColor: Colors.transparent)
                      .whenComplete(() {
                    setState(() {});
                  });
                },
                child: CircleAvatar(
                  radius: 0.046.width,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    "${PathConst.SVG}add_photo.svg",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            0.02.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.sp),
              child: Text(
                _controller.homePageController.userAccounts[widget.accountIndex]
                        .publicKeyHash ??
                    "public key",
                style: labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            0.02.vspace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Account Name",
                style:
                    labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            NaanTextfield(
                hint: "Account Name",
                focusNode: nameFocusNode,
                controller: _controller.accountNameController,
                onSubmitted: (value) {
                  setState(() {
                    if (_accountController.homePageController
                        .userAccounts[widget.accountIndex].publicKeyHash!
                        .contains(_accountController
                            .userAccount.value.publicKeyHash!)) {
                      _accountController.userAccount.update((val) {
                        val!.name = value;
                      });
                    }
                    _controller.editAccountName(widget.accountIndex, value);
                  });
                }),
            0.04.vspace,
            SolidButton(
              title: "Save Changes",
              onPressed: () {
                if (_accountController.homePageController
                    .userAccounts[widget.accountIndex].publicKeyHash!
                    .contains(
                        _accountController.userAccount.value.publicKeyHash!)) {
                  _accountController.userAccount.update((val) {
                    val!.name = _controller.accountNameController.value.text;
                  });
                }
                _controller.editAccountName(widget.accountIndex,
                    _controller.accountNameController.value.text);
                _accountController.isAccountEditable.value = false;
                Get
                  ..back()
                  ..back();
              },
            ),
          ]);
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
                        _controller.editUserProfilePhoto(
                            accountIndex: widget.accountIndex,
                            imagePath: imagePath,
                            imageType: AccountProfileImageType.file);

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
                      Get.bottomSheet(avatarPicker(), isScrollControlled: true);
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
                      _controller.editUserProfilePhoto(
                          imageType: AccountProfileImageType.assets,
                          imagePath: ServiceConfig.allAssetsProfileImages[0],
                          accountIndex: widget.accountIndex);

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
                onTap: () => Get.back(),
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
                  image:
                      _controller.showUpdatedProfilePhoto(widget.accountIndex),
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
                    _controller.editUserProfilePhoto(
                        imageType: AccountProfileImageType.assets,
                        imagePath: ServiceConfig.allAssetsProfileImages[index],
                        accountIndex: widget.accountIndex);
                    _accountController.userAccount.update((val) {
                      val?.imageType = AccountProfileImageType.assets;
                      val?.profileImage =
                          ServiceConfig.allAssetsProfileImages[index];
                    });
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
                Get.back();
                Get.back();
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
