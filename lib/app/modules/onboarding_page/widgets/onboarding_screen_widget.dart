import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/modules/onboarding_page/controllers/onboarding_page_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class OnboardingWidget extends StatefulWidget {
  final OnboardingPageController controller;
  const OnboardingWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.controller.animateSlider());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:
      //     widget.controller.colorList[widget.controller.pageIndex()],
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: widget.controller.colorList[widget.controller.pageIndex()],
        child: PageView.builder(
            controller: widget.controller.pageController,
            itemCount: 4,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              widget.controller.onPageChanged(value);
              setState(() {});
            },
            itemBuilder: (_, index) {
              return AnnotatedRegion(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarDividerColor: Colors.transparent,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarIconBrightness: Brightness.dark,
                  systemNavigationBarColor: widget.controller.colorList[index],
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 1.height,
                  width: 1.width,
                  color: widget
                      .controller.colorList[widget.controller.pageIndex()],
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Lottie.asset(
                        widget.controller.onboardingMessages.keys
                            .elementAt(index),
                        animate: true,
                        frameRate: FrameRate(60),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        repeat: true,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 0.65.height,
                          width: 1.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              stops: const [0.3, 0.5, 1],
                              colors: [
                                widget.controller
                                    .colorList[widget.controller.pageIndex()]
                                    .withOpacity(1),
                                widget.controller
                                    .colorList[widget.controller.pageIndex()]
                                    .withOpacity(0.9),
                                widget.controller
                                    .colorList[widget.controller.pageIndex()]
                                    .withOpacity(0),
                              ],
                              begin: const Alignment(0, 0),
                              end: const Alignment(0, -0.8),
                              tileMode: TileMode.decal,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(-0.1, 0.6),
                        child: Text(
                          widget.controller.onboardingMessages.values
                              .elementAt(index),
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: 'Space Grotesk',
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
