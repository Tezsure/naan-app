import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class NftGalleryWidget extends GetView<NftGalleryWidgetController> {
  const NftGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 26.sp,
        right: 26.sp,
      ),
      height: 0.87.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.arP),
        color: const Color(0xFF1E1C1F),
      ),
      child: Obx(
        () => controller.nftGalleryList.isEmpty
            ? _getNoGalleryStateWidget()
            : _getGalleryWidget(),
      ),
    );
  }

  Widget _getNoGalleryStateWidget() => GestureDetector(
        onTap: () => controller.showCreateNewNftGalleryBottomSheet(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(
                  top: 22.sp,
                  right: 18.3.sp,
                ),
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  "assets/nft_page/svg/add_icon.svg",
                  height: 38.33.sp,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.all(
                  22.sp,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create new gallery",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(
                      height: 4.sp,
                    ),
                    Text(
                      "Use a gallery to display NFTs from\nmultiple accounts",
                      style: TextStyle(
                          color: const Color(0xFF958E99),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          letterSpacing: .5),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _getGalleryWidget() => GestureDetector(
        // onTap: () => controller.showCreateNewNftGalleryBottomSheet(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.arP),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              children: [
                ...List.generate(
                  controller.nftGalleryList.length,
                  (index) => GestureDetector(
                    onTap: () => controller.openGallery(index),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.network(
                            "https://assets.objkt.media/file/assets-003/${controller.nftGalleryList[index].nftTokenModel!.faContract}/${controller.nftGalleryList[index].nftTokenModel!.tokenId.toString()}/thumb288",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: EdgeInsets.all(
                              22.sp,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.nftGalleryList[index].name!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 4.sp,
                                ),
                                Text(
                                  controller.nftGalleryList[index]
                                      .nftTokenModel!.name!,
                                  style: TextStyle(
                                    color: const Color(0xFF958E99),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _getNoGalleryStateWidget(),
              ],
            ),
          ),
        ),
      );
}