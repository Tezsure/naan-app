import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../controllers/nft_gallery_controller.dart';

class NftGalleryView extends GetView<NftGalleryController> {
  NftGalleryView({super.key});
  @override
  final controller = Get.put(NftGalleryController());
  @override
  Widget build(BuildContext context) {
    return const NFTDetailView();
    // return const NFTCollectionView();
  }
}

class NFTDetailView extends GetView<NftGalleryController> {
  const NFTDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      maxChildSize: 0.96,
      minChildSize: 0.6,
      builder: ((context, scrollController) => DefaultTabController(
            length: 2,
            child: Container(
              width: 1.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                gradient: GradConst.GradientBackground,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    0.01.vspace,
                    Center(
                      child: Container(
                        height: 5,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                    0.001.vspace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white)),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.share, color: Colors.white)),
                        IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.cast_rounded,
                                color: Colors.white)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0.02.height),
                      height: 0.5.height,
                      width: 1.width,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.asset(
                            '${PathConst.TEMP}nft_pic.png',
                            fit: BoxFit.cover,
                          )),
                          GestureDetector(
                            onTap: () {},
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 10.sp, bottom: 22.sp),
                                height: 36.sp,
                                width: 36.sp,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Transform.rotate(
                                  angle: pi / 180 * 135,
                                  child: const Icon(
                                    Icons.code_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.sp, right: 13.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'unstable dreams\n',
                                    style: labelSmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade60)),
                                TextSpan(
                                    text: 'Unstable #5\n', style: bodyLarge),
                                TextSpan(
                                  text:
                                      'Donec lectus nibh, consectetur vitae dolor ac, finibus\nsuscipit quam. Nunc at nunc turpis. Donec gravida',
                                  style: bodySmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            minWidth: 1,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {},
                            child: Text(
                              'See more',
                              textAlign: TextAlign.start,
                              style: labelMedium.copyWith(
                                  color: ColorConst.Primary),
                            ),
                          ),
                          0.01.vspace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '2\n',
                                      style: labelLarge,
                                      children: [
                                        TextSpan(
                                            text: 'Owned',
                                            style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade70))
                                      ])),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '40\n',
                                      style: labelLarge,
                                      children: [
                                        TextSpan(
                                            text: 'Owners',
                                            style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade70))
                                      ])),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '69\n',
                                      style: labelLarge,
                                      children: [
                                        TextSpan(
                                            text: 'Editions',
                                            style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade70))
                                      ])),
                            ],
                          ),
                          Center(
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: 0.02.height),
                              height: 0.12.height,
                              width: 1.width,
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: 'Current Price\n',
                                        style: labelSmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                        children: [
                                          TextSpan(
                                              text: '420.69 ',
                                              style: headlineSmall),
                                          WidgetSpan(
                                              child: SvgPicture.asset(
                                            '${PathConst.HOME_PAGE}svg/xtz.svg',
                                            height: 20,
                                          )),
                                          TextSpan(
                                              text: '\n\$596.21',
                                              style: labelSmall.copyWith(
                                                  color: ColorConst
                                                      .NeutralVariant.shade60)),
                                        ])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset('${PathConst.TEMP}nft_summary1.png'),
                      ),
                      title: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Created By ',
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade60),
                              children: [
                                TextSpan(
                                    text: tz1Shortner(
                                        'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
                                    style: labelMedium)
                              ])),
                    ),
                    Divider(
                      color: ColorConst.NeutralVariant.shade20,
                      endIndent: 14.sp,
                      indent: 14.sp,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset('${PathConst.TEMP}nft_summary2.png'),
                      ),
                      title: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Created By ',
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade60),
                              children: [
                                TextSpan(
                                    text: tz1Shortner(
                                        'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
                                    style: labelMedium)
                              ])),
                    ),
                    SizedBox(
                      width: 1.width,
                      height: 0.1.height,
                      child: TabBar(
                          padding: EdgeInsets.all(8.sp),
                          enableFeedback: true,
                          isScrollable: true,
                          indicatorColor: ColorConst.Primary,
                          unselectedLabelColor:
                              ColorConst.NeutralVariant.shade60,
                          unselectedLabelStyle: labelLarge,
                          labelColor: ColorConst.Primary.shade95,
                          labelStyle: labelLarge,
                          tabs: const [
                            Tab(
                              child: Text(
                                'Details',
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Item Activity',
                              ),
                            ),
                          ]),
                    ),
                    Obx(() => SizedBox(
                          height: controller.isExpanded.value
                              ? 0.4.height
                              : 0.2.height,
                          child: TabBarView(children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ExpansionTile(
                                      onExpansionChanged:
                                          controller.toggleExpanded,
                                      title: Text(
                                        'About Collection',
                                        style: labelSmall,
                                      ),
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.sp, right: 13.sp),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Image.asset(
                                                        '${PathConst.TEMP}nft_details.png'),
                                                  ),
                                                  0.04.hspace,
                                                  Text(
                                                    'stay a vision',
                                                    style: labelSmall,
                                                  ),
                                                ],
                                              ),
                                              0.01.vspace,
                                              Text(
                                                'Donec lectus nibh, consectetur vitae dolor ac, finibus suscipit quam. Nunc at nunc turpis. Donec gradvida',
                                                style: bodySmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade60),
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                  Divider(
                                    color: ColorConst.NeutralVariant.shade20,
                                    endIndent: 14.sp,
                                    indent: 14.sp,
                                  ),
                                  ExpansionTile(
                                      onExpansionChanged:
                                          controller.toggleExpanded,
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      title: Text(
                                        'Details',
                                        style: labelSmall,
                                      ),
                                      children: [
                                        Row(
                                          children: [
                                            0.04.hspace,
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                    text: 'Contract Address\n',
                                                    style: labelSmall,
                                                    children: [
                                                      TextSpan(
                                                          text: 'Token ID',
                                                          style: labelSmall)
                                                    ])),
                                            const Spacer(),
                                            RichText(
                                                textAlign: TextAlign.end,
                                                text: TextSpan(
                                                    text: 'Ox495f...7b5e',
                                                    style: bodySmall.copyWith(
                                                        color:
                                                            ColorConst.Primary),
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.open_in_new,
                                                          size: 14,
                                                          color: ColorConst
                                                              .Primary,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text: '\n13951734451',
                                                          style: bodySmall.copyWith(
                                                              color: ColorConst
                                                                  .NeutralVariant
                                                                  .shade60))
                                                    ])),
                                            0.04.hspace,
                                          ],
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Column(
                                children: [
                                  0.01.vspace,
                                  Material(
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: SvgPicture.asset(
                                          '${PathConst.SVG}bi_arrow.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      title: Text(
                                        'Transfer',
                                        style: labelMedium,
                                      ),
                                      subtitle: Text(
                                        'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                                        style: bodySmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                      ),
                                      trailing: Text(
                                        '1.5 hours ago',
                                        style: labelSmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                      ),
                                    ),
                                  ),
                                  0.01.vspace,
                                  Material(
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: SvgPicture.asset(
                                          '${PathConst.SVG}cart.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      title: Text(
                                        'Sale',
                                        style: labelMedium,
                                      ),
                                      subtitle: Text(
                                        'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                                        style: bodySmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                      ),
                                      trailing: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: '123 ',
                                          style: labelSmall,
                                          children: [
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: SvgPicture.asset(
                                                '${PathConst.HOME_PAGE}svg/xtz.svg',
                                                height: 12.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\n2 days ago',
                                              style: labelSmall.copyWith(
                                                  color: ColorConst
                                                      .NeutralVariant.shade60),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class NFTCollectionView extends GetView<NftGalleryController> {
  const NFTCollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: GradConst.GradientBackground,
        ),
        height: 0.95.height,
        width: 1.width,
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'NFTs',
                    style: titleMedium,
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    )
                  ]),
              TabBar(
                  enableFeedback: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 0.04.width),
                  isScrollable: true,
                  indicatorColor: ColorConst.Primary,
                  tabs: [
                    Tab(
                      child: Text(
                        'Collected',
                        style: labelMedium,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Created',
                        style: labelMedium,
                      ),
                    ),
                  ]),
              SizedBox(
                height: 0.06.height,
                child: ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                  itemCount: controller.nftChips.length,
                  physics: const BouncingScrollPhysics(
                      parent: ClampingScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.sp),
                        child: Chip(
                          autofocus: true,
                          iconTheme:
                              const IconThemeData(color: Colors.transparent),
                          label: Text(
                            controller.nftChips[index],
                            style: labelSmall,
                          ),
                          backgroundColor: ColorConst.NeutralVariant.shade20,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          side: BorderSide(
                            color: ColorConst.NeutralVariant.shade60,
                            width: 1,
                          ),
                          labelStyle: labelSmall,
                          visualDensity: VisualDensity.compact,
                        ),
                      )),
                ),
              ),
              Expanded(
                child: TabBarView(children: [
                  MasonryGridView.builder(
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.sp, vertical: 10.sp),
                      gridDelegate:
                          const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                      ),
                      itemBuilder: (_, i) {
                        return GalleryImage(
                            galleryItems: listOfUrls
                                .map(
                                    (e) => GalleryItemModel(id: e, imageUrl: e))
                                .toList());
                      }),
                  Container(),
                ]),
              ),
            ],
          ),
        ));
  }
}

class ImageFeedDesign extends StatelessWidget {
  const ImageFeedDesign({super.key, required this.image});
  final String image;
  final String place = 'Bali';
  final String distance = '2.834 km';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 - 30,
          height: _getHeight(),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(image),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                distance,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getHeight() {
    double defaultValue = 170.0;
    Random random = Random();

    return defaultValue + random.nextInt(100);
  }
}

List<String> listOfUrls = [
  "https://cosmosmagazine.com/wp-content/uploads/2020/02/191010_nature.jpg",
  "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
  "https://isha.sadhguru.org/blog/wp-content/uploads/2016/05/natures-temples.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
  "https://s23574.pcdn.co/wp-content/uploads/Singular-1140x703.jpg",
  "https://www.expatica.com/app/uploads/sites/9/2017/06/Lake-Oeschinen-1200x675.jpg",
];

class GalleryImage extends StatelessWidget {
  final List<GalleryItemModel> galleryItems;
  final String? titleGallery;
  final int numOfShowImages;

  const GalleryImage({
    super.key,
    required this.galleryItems,
    this.titleGallery,
    this.numOfShowImages = 4,
  }) : assert(numOfShowImages <= galleryItems.length);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getHeight(),
      decoration: BoxDecoration(
        color: ColorConst.NeutralVariant.shade80.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                  primary: false,
                  itemCount: galleryItems.length > 4
                      ? numOfShowImages
                      : galleryItems.length,
                  padding: const EdgeInsets.all(0),
                  semanticChildCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return index < galleryItems.length - 1 &&
                            index == numOfShowImages - 1
                        ? _expandedNftImageCollectionButton(index)
                        : GalleryItemThumbnail(
                            galleryItem: galleryItems[index],
                            onTap: () {
                              // openImageFullScreen(index);
                            },
                          );
                  }),
            ),
            0.01.vspace,
            RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                    text: 'Flowers & Bytes\n',
                    style: labelMedium,
                    children: [
                      TextSpan(text: 'Felix le peintre', style: labelSmall)
                    ])),
          ],
        ),
      ),
    );
  }

  double _getHeight() {
    double defaultValue = 0.29.height;
    Random random = Random();

    return defaultValue + random.nextInt(100);
  }

// build image with number for other images
  Widget _expandedNftImageCollectionButton(int index) {
    return GestureDetector(
      onTap: () {
        // openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryItemThumbnail(
            galleryItem: galleryItems[index],
          ),
          Container(
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                "+${galleryItems.length - index}",
                style: titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryItemModel {
  GalleryItemModel({required this.id, required this.imageUrl});
// id image (image url) to use in hero animation
  final String id;
  // image url
  final String imageUrl;
}

// to show image in GridView
class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail(
      {super.key, required this.galleryItem, this.onTap});

  final GalleryItemModel galleryItem;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: galleryItem.id,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: galleryItem.imageUrl,
          height: 100.0,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
