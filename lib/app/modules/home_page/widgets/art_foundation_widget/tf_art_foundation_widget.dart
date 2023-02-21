import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/choose_payment_method.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../account_switch_widget/account_switch_widget.dart';

class TFArtFoundationWidget extends StatelessWidget {
  const TFArtFoundationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        String url =
            "https://tezos.foundation/tezos-foundation-permanent-art-collection/digital-art-gallery-by-misan-harriman/";
        // Get.to(BuyNFTPage(), arguments: url);
        Get.bottomSheet(
          const DappBrowserView(),
          barrierColor: Colors.white.withOpacity(0.09),
          settings: RouteSettings(
            arguments: url,
          ),
          isScrollControlled: true,
        );
      },
      child: HomeWidgetFrame(
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.arP),
                child: NFTImage(
                  nftTokenModel: AppConstant.tfCollection!,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.arP, vertical: 16.arP),
                    child: _buildIcon()),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: AppConstant.homeWidgetDimension / 2,
                  width: double.infinity,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      // ignore: prefer_const_constructors
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // ignore: prefer_const_literals_to_create_immutables
                          colors: [
                        Colors.transparent,
                        Colors.grey[900]!.withOpacity(0.6),
                        Colors.grey[900]!.withOpacity(0.99),
                      ])),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.arP),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("TF Permanent", style: labelMedium),
                      Text("Art Collection", style: labelMedium),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(8.arP)),
      padding: EdgeInsets.all(8.arP),
      height: 33.arP,
      width: 33.arP,
      child: Image.asset("${PathConst.HOME_PAGE}tf_icon.png"),
    );
  }
}