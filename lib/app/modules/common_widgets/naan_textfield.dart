// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NaanTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onTextChange;
  final String? hint;
  final TextStyle? hintTextSyle;
  final Color? backgroundColor;
  final Function()? onEditingComplete;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;

  const NaanTextfield(
      {Key? key,
      this.onEditingComplete,
      this.controller,
      this.hint,
      this.onTextChange,
      this.backgroundColor,
      this.hintTextSyle,
      this.onSubmitted,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: backgroundColor ?? Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            cursorColor: ColorConst.Primary,
            style: bodyMedium,
            onChanged: onTextChange,
            onSubmitted: onSubmitted,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
                hintStyle: hintTextSyle ??
                    bodyMedium.apply(color: Colors.white.withOpacity(0.2)),
                hintText: hint,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

class NaanTextFormfield extends StatelessWidget {
  const NaanTextFormfield({Key? key, this.controller, this.height, this.hint})
      : super(key: key);
  final TextEditingController? controller;
  final double? height;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: TextFormField(
            controller: controller,
            cursorColor: ColorConst.Primary,
            maxLines: 100,
            style: bodyMedium,
            decoration: InputDecoration(
                hintStyle:
                    bodyMedium.apply(color: Colors.white.withOpacity(0.2)),
                hintText: hint,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
