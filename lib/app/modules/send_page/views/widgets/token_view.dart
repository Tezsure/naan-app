import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import 'token_textfield.dart';

class TokenView extends GetView<SendPageController> {
  const TokenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.Neutral.shade10.withOpacity(0.6),
            child: Obx(
              () => ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: controller.amountTileError.value
                            ? ColorConst.NaanRed
                            : controller.amountTileFocus.value
                                ? ColorConst.Neutral.shade70
                                : Colors.transparent),
                    borderRadius: BorderRadius.circular(8)),
                dense: true,
                leading: SizedBox(
                  width: 0.5.width,
                  child: TokenSendTextfield(
                    focusNode: controller.amountFocusNode.value,
                    hintText: '0.00',
                    controller: controller.amountController,
                    isError: controller.amountTileError,
                    onChanged: (val) {
                      controller.amountText.value = val;
                      if (!controller.amountFocusNode.value.hasFocus) {
                        return;
                      }
                      String formatedAmount = formatEnterAmount(val);
                      if (val.contains(".")) {
                        if (formatedAmount != val) {
                          controller.amountController.text = formatedAmount;
                          controller.amountController.selection =
                              TextSelection.fromPosition(
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
                    },
                  ),
                ),
                trailing: SizedBox(
                  width: 0.27.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!controller.amountFocusNode.value.hasFocus) {
                              controller.amountFocusNode.value.requestFocus();
                            }
                            controller.amountController.text = controller
                                .selectedTokenModel!.balance
                                .toString();
                            controller.amountController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                offset: controller.amountController.text.length,
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
                                color: ColorConst.Neutral.shade80
                                    .withOpacity(0.2)),
                            child: Center(
                              child: Text('Max',
                                  style: labelSmall.copyWith(
                                      color: ColorConst.Primary.shade60)),
                            ),
                          ),
                        ),
                        0.02.hspace,
                        controller.selectedTokenModel != null
                            ? Text(
                                controller.selectedTokenModel!.symbol!,
                                style: labelLarge.copyWith(
                                    color: ColorConst.Neutral.shade70),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        0.008.vspace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            child: Obx(() => ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: controller.amountUsdTileError.value
                            ? ColorConst.NaanRed
                            : !controller.amountTileFocus.value
                                ? ColorConst.NeutralVariant.shade60
                                : Colors.transparent),
                    borderRadius: BorderRadius.circular(8)),
                dense: true,
                leading: SizedBox(
                  width: 0.7.width,
                  child: TokenSendTextfield(
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
                            : ColorConst.NeutralVariant.shade30),
                  ),
                ),
                trailing: Text(
                  'USD',
                  style: labelLarge.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ))),
          ),
        ),
      ],
    );
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