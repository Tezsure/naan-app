import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/info_stories/models/story_page/views/story_page_view.dart';
import 'package:naan_wallet/mock/mock_data.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../custom_packages/animated_scroll_indicator/effects/expanding_dots_effects.dart';
import '../../custom_packages/animated_scroll_indicator/smooth_page_indicator.dart';
import 'account_balance/account_balance_widget.dart';
import 'dapp_search_widget/dapp_search_widget.dart';
import 'how_to_import_wallet/how_to_import_wallet_widget.dart';
import 'nft/nft_widget.dart';
import 'tez_balance_widget/tez_balance_widget.dart';
import 'tezos_headline/tezos_headline_widget.dart';
import 'token_balance/token_balance_widget.dart';

/// Check examples from lib/app/modules/widgets/ before adding your custom widget
final List<Widget> registeredWidgets = [
  StoryPageView(
    profileImagePath: MockData.naanInfoStory.values.toList(),
    storyTitle: MockData.naanInfoStory.keys.toList(),
  ),
  // const ActionButtonGroupWidget(),
  const AccountWidgets(),
  const CommunityProducts(),
  const HowToImportWalletWidget(),
  AccountBalanceWidget(),
  TokenBalanceWidget(),
  const NftWidget(),
  TezBalanceWidget(),
  const DappSearchWidget(),
  TezosHeadlineWidget(),
];

class CommunityProducts extends StatelessWidget {
  const CommunityProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.2.height,
      width: 1.width,
      child: Stack(
        children: [
          ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 165,
                      width: 0.85.width,
                      decoration: BoxDecoration(
                        color: const Color(0xff343131),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: AnimatedSmoothIndicator(
                activeIndex: 0,
                count: 5,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AccountWidgets extends StatelessWidget {
  const AccountWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Wallets',
          style: titleSmall.copyWith(color: ColorConst.NeutralVariant.shade50),
        ),
        13.vspace,
        SizedBox(
          width: 1.width,
          height: 0.3.height,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, index) => index == 10 - 1
                  ? const AddAccountWidget()
                  : const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: AccountsContainer(),
                    )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            10.hspace,
            SizedBox(
              height: 10,
              width: 0.55.width,
              child: ListView.builder(
                itemCount: 20,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: ((context, index) => index ==
                        20 - 1 //TODO Change with the last of the list
                    ? Icon(
                        Icons.add,
                        color: index ==
                                20 -
                                    1 // TODO Change with last element of the list
                            ? Colors.white
                            : ColorConst.NeutralVariant.shade20,
                        size: 10,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                      )),
              ),
            ),
            const Spacer(),
            Text(
              'manage account',
              style: labelSmall.copyWith(color: ColorConst.Neutral.shade95),
            ),
          ],
        ),
      ],
    );
  }
}

class AddAccountWidget extends StatelessWidget {
  const AddAccountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorConst.Primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 37.0, top: 66),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConst.Primary.shade60,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                  6.hspace,
                  Text(
                    'Add Account',
                    style: labelSmall,
                  ),
                ],
              ),
              16.vspace,
              Text(
                'Create new account and add to\nthe stack ',
                style: labelSmall,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class AccountsContainer extends StatelessWidget {
  const AccountsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              'assets/svg/accounts/account_1.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 211,
          width: 326,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: const Alignment(-0.05, 0),
                end: const Alignment(1.5, 0),
                colors: [
                  ColorConst.Primary.shade50,
                  // const Color(0xff9961EC),
                  const Color(0xff4E4D4D).withOpacity(0),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 31.0, top: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Account One',
                    style: labelSmall,
                  ),
                  10.hspace,
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 8,
                    minRadius: 8,
                  )
                ],
              ),
              8.vspace,
              Row(
                children: [
                  Text(
                    'tz...fDzg',
                    style: bodySmall,
                  ),
                  1.hspace,
                  const Icon(
                    Icons.copy,
                    size: 11,
                    color: Colors.white,
                  ),
                ],
              ),
              15.vspace,
              Row(
                children: [
                  Text(
                    '252.25',
                    style: headlineSmall,
                  ),
                  10.hspace,
                  SvgPicture.asset(
                    'assets/svg/path.svg',
                    color: Colors.white,
                    height: 20,
                    width: 15,
                  ),
                ],
              ),
              17.vspace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(),
                    elevation: 1,
                    padding: const EdgeInsets.all(8),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    enableFeedback: true,
                    onPressed: () {},
                    fillColor: ColorConst.Primary.shade0,
                    shape: const CircleBorder(side: BorderSide.none),
                    child: const Icon(
                      Icons.turn_right_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  16.hspace,
                  Transform.rotate(
                    angle: -math.pi / 1,
                    child: RawMaterialButton(
                      enableFeedback: true,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      elevation: 1,
                      onPressed: () {},
                      fillColor: ColorConst.Primary.shade0,
                      shape: const CircleBorder(side: BorderSide.none),
                      child: const Icon(
                        Icons.turn_right_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
