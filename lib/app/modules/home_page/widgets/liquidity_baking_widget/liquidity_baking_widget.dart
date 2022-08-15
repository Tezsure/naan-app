import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/liquidity_baking_widget/widgets/custom_slider.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class LiquidityBakingWidget extends GetView<HomePageController> {
  final bool add = true;
  final bool activeButton = false;
  const LiquidityBakingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomePageController());
    return Container(
      width: 0.92.width,
      decoration: BoxDecoration(
        color: ColorConst.Tertiary,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
            image: AssetImage(
              "${PathConst.HOME_PAGE.IMAGES}coins_background.png",
            ),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter),
      ),
      child: Column(
        children: [
          0.075.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Earn ",
                style: headlineMedium.apply(color: Colors.black),
              ),
              Text(
                "31% APR",
                style: headlineMedium.apply(color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "on your ",
                style: headlineMedium.apply(color: Colors.black),
              ),
              SvgPicture.asset(
                "${PathConst.HOME_PAGE.SVG}xtz.svg",
                color: Colors.black,
              )
            ],
          ),
          0.027.vspace,
          Container(
            height: 0.045.height,
            width: 0.42.width,
            decoration: BoxDecoration(
              color: ColorConst.Tertiary.shade90,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Add',
                        style: labelSmall.copyWith(color: ColorConst.Tertiary),
                      ),
                      Text(
                        'Remove',
                        textAlign: TextAlign.center,
                        style: labelSmall.copyWith(color: ColorConst.Tertiary),
                      ),
                    ],
                  ),
                ),
                Obx(() => AnimatedAlign(
                      duration: controller.animationDuration,
                      alignment: controller.isEnabled.value
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: MaterialButton(
                        elevation: 0,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        onPressed: () => controller.onTapLiquidityBaking(),
                        child: Text(
                          controller.isEnabled.value ? 'Remove' : 'Add',
                          style: labelSmall.copyWith(color: Colors.white),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          0.01.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => SizedBox(
                    height: 67,
                    width: 0.2.width,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      cursorWidth: 1,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      style: headlineLarge.apply(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: controller.isEnabled.value ? '7648' : null,
                        labelStyle: headlineLarge.copyWith(color: Colors.black),
                        border: InputBorder.none,
                        hintText: !controller.isEnabled.value ? "0.00" : null,
                        hintStyle: headlineLarge.apply(
                            color: ColorConst.Tertiary.shade60),
                      ),
                    ),
                  )),
              0.01.hspace,
              SvgPicture.asset(
                "${PathConst.HOME_PAGE.SVG}xtz.svg",
                color: Colors.black,
                height: 34,
              ),
            ],
          ),
          0.01.vspace,
          Obx(() => Text(
                !controller.isEnabled.value
                    ? "SIRS : 0"
                    : "Available SIRS : 123",
                style: labelSmall.apply(color: Colors.black),
              )),
          0.005.vspace,
          Text(
            "1 XTZ (\$.1.56) = 0.00007278 SIRS",
            style: labelSmall.apply(color: Colors.black),
          ),
          Center(
            child: Obx(() => LiquidityBakingSlider(
                  onChanged: controller.onSliderChange,
                  sliderValue: controller.sliderValue.value,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17, top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    5,
                    (index) => Text(
                          "${index > 0 ? index * 25 : index}%",
                          style: labelLarge.copyWith(
                              color: (index * 25) < 24
                                  ? Colors.black
                                  : ColorConst.Tertiary.shade60,
                              fontSize: 12),
                        ))),
          ),
          0.02.vspace,
          Obx(() => MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                height: 40,
                color: (!controller.isEnabled.value ||
                            controller.isEnabled.value) &&
                        controller.sliderValue.value > 5
                    ? Colors.black
                    : ColorConst.Tertiary.shade90,
                elevation: 0,
                onPressed: () {},
                child: SizedBox(
                  width: 0.75.width,
                  child: Center(
                    child: Text(
                      !controller.isEnabled.value
                          ? "Get Sirius"
                          : "Remove Liquidity",
                      style: labelSmall.apply(
                          color: (!controller.isEnabled.value ||
                                      controller.isEnabled.value) &&
                                  controller.sliderValue.value > 5
                              ? Colors.white
                              : ColorConst.Tertiary.shade80),
                    ),
                  ),
                ),
              )),
          0.038.vspace,
        ],
      ),
    );
  }
}

class LiquidityBakingSlider extends StatelessWidget {
  final double sliderValue;
  final Function(double) onChanged;
  const LiquidityBakingSlider(
      {Key? key, required this.sliderValue, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.width,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          thumbShape: const CustomRoundSliderThumbShape(enabledThumbRadius: 10),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
          showValueIndicator: ShowValueIndicator.always,
          trackShape: const GradientRectSliderTrackShape(),
        ),
        child: Slider(
            max: 100,
            min: 0,
            value: sliderValue,
            label: sliderValue.toStringAsFixed(0),
            onChanged: onChanged),
      ),
    );
  }
}
