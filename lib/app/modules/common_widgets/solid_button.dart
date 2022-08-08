import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SolidButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onPressed;
  final Color? textColor;
  final double? height;
  final double? width;
  final Widget? rowWidget;
  final bool active;
  final Widget? child;
  final Color? disabledButtonColor;
  final Color? primaryColor;
  final double elevation;

  final Widget? inActiveChild;
  const SolidButton({
    Key? key,
    this.title = "",
    this.onPressed,
    this.textColor,
    this.height,
    this.width,
    this.rowWidget,
    this.active = true,
    this.child,
    this.inActiveChild,
    this.disabledButtonColor,
    this.primaryColor,
    this.elevation = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      onPressed: active ? onPressed : null,
      disabledColor: disabledButtonColor ??
          ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      color: primaryColor ?? ColorConst.Primary,
      splashColor: ColorConst.Primary.shade60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: height ?? 48,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     if (rowWidget != null) ...[rowWidget!, 10.w.hspace],
        //     Text(
        //       title,
        //       style: titleSmall.apply(
        //         color: textColor ?? ColorConst.Neutral,
        //       ),
        //     ),
        //   ],
        // ),
        child: child != null
            ? (active ? child : inActiveChild)
            : Text(
                title,
                style: titleSmall.apply(
                    color: active
                        ? textColor ?? ColorConst.Neutral.shade95
                        : ColorConst.NeutralVariant.shade60),
              ),
      ),
    );
  }
}
