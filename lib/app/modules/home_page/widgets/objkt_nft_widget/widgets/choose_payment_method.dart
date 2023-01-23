import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/widgets/crypto_tab_widgets/token_checkbox.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/controllers/buy_nft_controller.dart';

import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/styles/styles.dart';

class ChoosePaymentMethod extends StatelessWidget {
  ChoosePaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final buyNftController = Get.put(BuyNFTController());
    final accountSummaryController = Get.put(AccountSummaryController());
    return SizedBox(
      height: 0.7.height,
      child: NaanBottomSheet(
        height: 0.7.height,
        isScrollControlled: true,
        title: "Choose payment",
        bottomSheetHorizontalPadding: 16.arP,
        bottomSheetWidgets: [
          0.012.vspace,
          ListTile(
            onTap: buyNftController.buyWithCreditCard,
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: SvgPicture.asset("assets/svg/credit-card.svg"),
            title: Text(
              "Credit card",
              style: labelLarge,
            ),
            subtitle: Text(
              "Powered by wert.io",
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            ),
          ),
          const Divider(
            color: ColorConst.darkGrey,
            thickness: 1,
          ),
          Obx(
            () => buyNftController.accountTokens.isEmpty
                ? Center(child: noTokens())
                : ListView.builder(
                    itemCount: buyNftController.accountTokens.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Obx(
                        () => _tokenBox(
                          accountSummaryController.xtzPrice.value,
                          buyNftController.accountTokens[index],
                          index,
                          buyNftController,
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget noTokens() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        CircularProgressIndicator(
          color: ColorConst.Primary,
        )
      ],
    );
  }

  Widget _tokenBox(double xtzPrice, AccountTokenModel token, int index,
          BuyNFTController buyNftController) =>
      TokenCheckbox(
        xtzPrice: xtzPrice,
        tokenModel: token,
        isEditable: false,
        onCheckboxTap: () => {buyNftController.selectMethod(token)},
      );
}
