import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/receive_page_controller.dart';

class ReceivePageView extends GetView<ReceivePageController> {
  const ReceivePageView({super.key});

  final String _accountName = "accountName";
  final String _accountAddress = "tzkeibotkxxkjpbmvfbv4a8ov5rafrdmf9";
  @override
  Widget build(BuildContext context) {
    Get.put(ReceivePageController());
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        height: 0.92.height,
        width: 1.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            gradient: GradConst.GradientBackground),
        child: Column(
          children: [
            0.005.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            0.017.vspace,
            Text(
              'Receive',
              style: titleMedium,
            ),
            0.058.vspace,
            Text(
              'You can send TEZ or any other Tezos\nbased asset to this address using\nTezos network.',
              textAlign: TextAlign.center,
              style: bodyMedium.apply(color: ColorConst.NeutralVariant.shade60),
            ),
            0.039.vspace,
            qrCode(),
            0.047.vspace,
            GestureDetector(
              onTap: () {
                controller.copyAddress(_accountAddress);
              },
              child: Text(
                _accountName,
                style: titleLarge,
              ),
            ),
            0.01.vspace,
            Text(
              _accountAddress,
              style: bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
            0.047.vspace,
            shareButton(),
            0.06.vspace,
          ],
        ),
      ),
    );
  }

  Container qrCode() {
    return Container(
      height: 0.3.height,
      width: 0.3.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      alignment: Alignment.center,
      child: QrImage(
        data: _accountAddress,
        padding: const EdgeInsets.all(20),
        gapless: false,
        eyeStyle:
            const QrEyeStyle(eyeShape: QrEyeShape.circle, color: Colors.black),
        embeddedImageEmitsError: true,
        embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(48, 48)),
        dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
      ),
    );
  }

  Widget shareButton() {
    return GestureDetector(
      onTap: () {
        Share.share(_accountAddress);
      },
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.share_sharp,
              size: 20,
              color: Colors.white,
            ),
            Text(
              'Share',
              style: titleSmall,
            )
          ],
        ),
      ),
    );
  }
}