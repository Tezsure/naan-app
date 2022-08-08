import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';

class CommunityProducts extends StatefulWidget {
  const CommunityProducts({Key? key}) : super(key: key);

  @override
  State<CommunityProducts> createState() => _CommunityProductsState();
}

class _CommunityProductsState extends State<CommunityProducts> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.25.height,
      width: 1.width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Explore DApps',
              style:
                  titleSmall.copyWith(color: ColorConst.NeutralVariant.shade50),
            ),
          ),
          PageView.builder(
            itemCount: 5,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 30),
              child: Container(
                height: 165,
                width: 0.85.width,
                decoration: BoxDecoration(
                  color: const Color(0xff343131),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/temp/community.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 10,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == currentIndex
                                  ? Colors.white
                                  : ColorConst.NeutralVariant.shade40),
                        ),
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
