import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import 'token_textfield.dart';

enum TextfieldType { token, usd }

class TokenView extends StatelessWidget {
  SendPageController controller;
  TokenView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: Obx(
            () => ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              dense: true,
              leading: SizedBox(
                width: 0.5.width,
                child: TokenSendTextfield(
                  textfieldType: TextfieldType.token,
                  onTap: () {
                    controller.selectedTextfieldType.value =
                        TextfieldType.token;
                  },
                  focusNode: controller.amountFocusNode.value,
                  hintText: '0.00',
                  hintStyle: headlineMedium.copyWith(
                    color: controller.amount.value.isNumericOnly &&
                            controller.amount.value.isNotEmpty
                        ? ColorConst.NeutralVariant.shade60
                        : ColorConst.NeutralVariant.shade30,
                    fontSize: 28.arP,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: controller.amountController,
                  isError: (controller.amountTileError.value ||
                          controller.amountUsdTileError.value)
                      .obs,
                  onChanged: _onChange,
                ),
              ),
              trailing: SizedBox(
                width: 0.3.width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      controller.selectedTextfieldType.value ==
                              TextfieldType.token
                          ? GestureDetector(
                              onTap: () {
                                if (!controller
                                    .amountFocusNode.value.hasFocus) {
                                  controller.amountFocusNode.value
                                      .requestFocus();
                                }
                                controller.amountController.text = (controller
                                            .selectedTokenModel!.balance -
                                        (double.parse(
                                                controller.estimatedFee.value) /
                                            controller.xtzPrice.value))
                                    .toString();
                                controller.amountController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                    offset:
                                        controller.amountController.text.length,
                                  ),
                                );
                                _onChange(controller.amountController.text);
                              },
                              child: Container(
                                height: 24,
                                width: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFF332F37)),
                                child: Center(
                                  child: Text('Max',
                                      style: labelMedium.copyWith(
                                          color: const Color(0xFF625C66))),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      0.02.hspace,
                      controller.selectedTokenModel != null
                          ? Text(
                              controller.selectedTokenModel!.symbol!,
                              style: labelLarge.copyWith(
                                  color: const Color(0xFF625C66)),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        0.008.vspace,
        Material(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: Obx(() => ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                dense: true,
                leading: SizedBox(
                  width: 0.7.width,
                  child: TokenSendTextfield(
                    textfieldType: TextfieldType.usd,
                    onTap: () {
                      controller.selectedTextfieldType.value =
                          TextfieldType.usd;
                    },
                    controller: controller.amountUsdController,
                    onChanged: (val) {
                      controller.amountText.value = val;
                      if (controller.amountFocusNode.value.hasFocus) {
                        return;
                      }
                      if (val.isEmpty) {
                        controller.amountController.text = "";
                        return;
                      }
                      if (double.parse(val) >
                          (controller.selectedTokenModel!.name == "Tezos"
                              ? controller.selectedTokenModel!.balance *
                                  controller.xtzPrice.value
                              : controller.selectedTokenModel!.balance *
                                  controller.selectedTokenModel!.currentPrice! *
                                  controller.xtzPrice.value)) {
                        controller.amountUsdTileError.value = true;
                      } else {
                        controller.amountUsdTileError.value = false;
                      }
                      calculateValuesAndUpdate(val, true);
                    },
                    isError: controller.amountUsdTileError,
                    hintText: '0.00',
                    hintStyle: headlineMedium.copyWith(
                      color: controller.amount.value.isNumericOnly &&
                              controller.amount.value.isNotEmpty
                          ? ColorConst.NeutralVariant.shade60
                          : ColorConst.NeutralVariant.shade30,
                      fontSize: 28.arP,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing: SizedBox(
                  width: 0.27.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        controller.selectedTextfieldType.value ==
                                TextfieldType.usd
                            ? GestureDetector(
                                onTap: () {
                                  controller.amountController.text =
                                      controller.selectedTokenModel != null
                                          ? (controller.selectedTokenModel!
                                                      .balance -
                                                  (double.parse(controller
                                                          .estimatedFee.value) /
                                                      controller
                                                          .xtzPrice.value))
                                              .toString()
                                          : "0";
                                  // print(controller.amountController.text);
                                  controller.amountController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset: controller
                                          .amountController.text.length,
                                    ),
                                  );
                                  controller.amountText.value =
                                      controller.amountController.text;
                                  calculateValuesAndUpdate(
                                      controller.amountController.text);
                                },
                                child: Container(
                                  height: 24,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: ColorConst.NeutralVariant.shade60
                                          .withOpacity(0.2)),
                                  child: Center(
                                    child: Text('Max',
                                        style: labelMedium.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60)),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        0.02.hspace,
                        Text(
                          'USD',
                          style: labelLarge.copyWith(
                              color: ColorConst.NeutralVariant.shade60),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  _onChange(val) {
    try {
      controller.amountText.value = val;
      if (!controller.amountFocusNode.value.hasFocus) {
        return;
      }
      String formatedAmount = formatEnterAmount(val);
      if (val.contains(".")) {
        if (formatedAmount != val) {
          controller.amountController.text = formatedAmount;
          controller.amountController.selection = TextSelection.fromPosition(
              TextPosition(offset: formatedAmount.length));
        }
      }
      if (formatedAmount.isNotEmpty &&
          double.parse(formatedAmount) >
              controller.selectedTokenModel!.balance) {
        controller.amountTileError.value = true;
      } else {
        controller.amountTileError.value = false;
      }
      if (formatedAmount.isNotEmpty) {
        calculateValuesAndUpdate(formatedAmount);
      } else {
        controller.amountUsdController.text = "";
      }
    } catch (e) {
      controller.amountText.value = "";
    }
  }

  void calculateValuesAndUpdate(String value, [bool isUsd = false]) {
    double newAmountValue = 0.0;
    double newUsdValue = 0.0;
    if (isUsd) {
      newAmountValue = controller.selectedTokenModel!.name == "Tezos"
          ? double.parse(value) / controller.xtzPrice.value
          : double.parse(value) /
              (controller.xtzPrice.value *
                  controller.selectedTokenModel!.currentPrice!);
    } else {
      newUsdValue = controller.selectedTokenModel!.name == "Tezos"
          ? double.parse(value) * controller.xtzPrice.value
          : double.parse(value) *
              controller.selectedTokenModel!.currentPrice! *
              controller.xtzPrice.value;
    }
    if (!isUsd &&
        controller.amountUsdController.text !=
            newUsdValue.toStringAsFixed(6).removeTrailing0) {
      controller.amountUsdController.text =
          newUsdValue.toStringAsFixed(6).removeTrailing0;
      controller.amountUsdController.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.amountUsdController.text.length));
    }
    if (isUsd &&
        controller.amountController.text !=
            newAmountValue
                .toStringAsFixed(controller.selectedTokenModel!.decimals)
                .removeTrailing0) {
      controller.amountController.text = newAmountValue
          .toStringAsFixed(controller.selectedTokenModel!.decimals)
          .removeTrailing0;
      controller.amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.amountController.text.length));
    }
  }

  String formatEnterAmount(String amount) {
    var decimalEnters = amount.substring(amount.indexOf(".") + 1).length;
    if (decimalEnters == 0) return amount;
    return double.parse(amount).toStringAsFixed(
        decimalEnters > controller.selectedTokenModel!.decimals
            ? controller.selectedTokenModel!.decimals
            : decimalEnters);
  }
}
