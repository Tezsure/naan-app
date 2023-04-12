import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/history_filter_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/pages/crypto_tab.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import '../../../../data/services/service_models/nft_token_model.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/token_info.dart';
import '../bottomsheets/history_filter_sheet.dart';
import '../bottomsheets/search_sheet.dart';
import '../bottomsheets/transaction_details.dart';
import '../widgets/history_tab_widgets/history_tile.dart';

class HistoryPage extends GetView<TransactionController> {
  final bool isNftTransaction;
  const HistoryPage({
    super.key,
    this.isNftTransaction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _buildBody(context);
    });
  }

  Widget? _itemBuilder(context, index) {
    if (controller.isFilterApplied.isTrue) {
      if (index == controller.filteredTransactionList.length) {
        return controller.isTransactionLoading.value
            ? const CupertinoActivityIndicator(color: ColorConst.Primary)
            :
            // controller.noMoreResults.isTrue
            //     ? SizedBox(
            //         height: 40.aR,
            //         child: Center(
            //           child: Text(
            //             'No more results'.tr,
            //             style: labelLarge.copyWith(
            //                 fontSize: 14.aR,
            //                 fontWeight: FontWeight.w400,
            //                 color: ColorConst.NeutralVariant.shade70),
            //           ),
            //         ),
            //       )
            //     :
            const SizedBox();
      } else {
        return _loadTokenTransaction(
            controller.filteredTransactionList[index],
            index,
            controller.filteredTransactionList[index].timeStamp!.isSameMonth(
                controller.filteredTransactionList[index == 0 ? 0 : index - 1]
                    .timeStamp!));
      }
    } else {
      if (index == controller.defaultTransactionList.length) {
        return Obx(() {
          return controller.isTransactionLoading.value
              ? const TokensSkeleton(
                  isScrollable: false,
                )
              :
              // controller.noMoreResults.isTrue
              //     ? SizedBox(
              //         height: 40.aR,
              //         child: Center(
              //           child: Text(
              //             'No more results'.tr,
              //             style: labelLarge.copyWith(
              //                 fontSize: 14.aR,
              //                 fontWeight: FontWeight.w400,
              //                 color: ColorConst.NeutralVariant.shade70),
              //           ),
              //         ),
              //       )
              //     :
              const SizedBox();
        });
      } else {
        return controller.defaultTransactionList[index].isNft
            ? _loadNFTTransaction(index)
            : _loadTokenTransaction(
                controller.defaultTransactionList[index],
                index,
                controller.defaultTransactionList[index].timeStamp!.isSameMonth(
                    controller
                        .defaultTransactionList[index == 0 ? 0 : index - 1]
                        .timeStamp!));
      }
    }
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            enableTwoLevel: true,
            // header: SizedBox(
            //     height: 50.arP,
            //     width: 50.arP,
            //     child: CupertinoActivityIndicator(color: ColorConst.Primary)),
            // footer: SizedBox(
            //   height: 50.arP,
            //   width: 50.arP,
            //   child: Container(),
            // ),
            controller: controller.refreshController,
            onLoading: () async {
              if (controller.noMoreResults.isTrue) {
                return controller.refreshController.loadNoData();
              }
              if (Get.isRegistered<HistoryFilterController>()) {
                if (controller.noMoreResults.isFalse) {
                  await controller.loadFilteredTransaction();
                }
              } else {
                if (controller.noMoreResults.isFalse) {
                  await controller.loadMoreTransaction();
                }
              }
              controller.refreshController.loadComplete();
            },
            onRefresh: () async {
              await controller.userTransactionLoader();
              controller.refreshController.refreshToIdle();
              controller.refreshController.resetNoData();
            },
            child: controller.userTransactionHistory.isEmpty
                ? _emptyState
                : controller.isFilterApplied.value &&
                        controller.filteredTransactionList.isEmpty
                    ? _emptyState
                    : Obx(() {
                        return ListView.builder(
                          itemBuilder: _itemBuilder,
                          itemCount: controller.isFilterApplied.value
                              ? controller.filteredTransactionList.length + 1
                              : controller.defaultTransactionList.length + 1,
                        );
                      }),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.aR),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.02.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingWidget(
                onPressed: () {
                  return Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchBottomSheet()));
                  // return CommonFunctions.bottomSheet(
                  //     const SearchBottomSheet());
                },
                child: Container(
                  height: 0.06.height,
                  width: 0.8.width,
                  padding: EdgeInsets.only(left: 14.5.aR),
                  decoration: BoxDecoration(
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.aR),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: ColorConst.NeutralVariant.shade60,
                        size: 22.aR,
                      ),
                      0.02.hspace,
                      Text(
                        'Search'.tr,
                        style: labelLarge.copyWith(
                            letterSpacing: 0.25.aR,
                            fontSize: 14.aR,
                            fontWeight: FontWeight.w400,
                            color: ColorConst.NeutralVariant.shade70),
                      )
                    ],
                  ),
                ),
              ),
              0.02.hspace,
              BouncingWidget(
                onPressed: () {
                  CommonFunctions.bottomSheet(HistoryFilterSheet());
                },
                child: SvgPicture.asset(
                  controller.isFilterApplied.value
                      ? "${PathConst.SVG}filter_selected.svg"
                      : '${PathConst.SVG}filter.svg',
                  fit: BoxFit.contain,
                  height: 24.aR,
                  color: ColorConst.Primary,
                ),
              ),
              0.01.hspace,
            ],
          ),
          0.02.vspace,
        ],
      ),
    );
  }

  Widget get _emptyState => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          0.03.vspace,
          SvgPicture.asset(
            "${PathConst.EMPTY_STATES}empty3.svg",
            height: 120.aR,
          ),
          0.02.vspace,
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "No transactions\n".tr,
                  style: titleLarge.copyWith(
                      fontSize: 22.aR, fontWeight: FontWeight.w700),
                  children: [
                    WidgetSpan(child: 0.04.vspace),
                    TextSpan(
                        text:
                            "Your crypto and NFT activity will appear\nhere once you start using your wallet"
                                .tr,
                        style: labelMedium.copyWith(
                            fontSize: 12.aR,
                            color: ColorConst.NeutralVariant.shade60))
                  ])),
        ],
      );

  Widget _loadTokenTransaction(TokenInfo token, int index, bool sameDate) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          index == 0
              ? Padding(
                  padding:
                      EdgeInsets.only(top: 8.arP, left: 16.arP, bottom: 16.arP),
                  child: Text(
                    DateFormat.MMMM()
                        // displaying formatted date
                        .format(token.timeStamp!),
                    style: labelLarge,
                  ),
                )
              : sameDate
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: 20.arP, left: 16.arP, bottom: 12.arP),
                      child: Text(
                        DateFormat.MMMM()
                            // displaying formatted date
                            .format(token.timeStamp!),
                        style: labelLarge,
                      ),
                    ),
          HistoryTile(
            tokenInfo: token,
            xtzPrice: controller.accController.xtzPrice.value,
            onTap: () => CommonFunctions.bottomSheet(
              TransactionDetailsBottomSheet(
                xtzPrice: controller.accController.xtzPrice.value,
                tokenInfo: token,
                userAccountAddress: controller
                    .accController.selectedAccount.value.publicKeyHash!,
              ),
            ),
          ),
        ],
      );

  Widget _loadNFTTransaction(int index) {
    final tokenList = Get.find<AccountSummaryController>().tokensList;
    if (controller.defaultTransactionList[index].token != null) {
      final transactionInterface = controller
          .defaultTransactionList[index].token!
          .transactionInterface(tokenList);
      controller.defaultTransactionList[index] =
          controller.defaultTransactionList[index].copyWith(
              nftTokenId: transactionInterface.tokenID,
              address: transactionInterface.contractAddress);
    }
    return FutureBuilder(
        future: ObjktNftApiService().getTransactionNFT(
            controller.defaultTransactionList[index].nftContractAddress!,
            controller.defaultTransactionList[index].nftTokenId!),
        builder: ((context, AsyncSnapshot<NftTokenModel> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: ColorConst.Primary,
              ),
            );
          } else if (snapshot.data!.name == null) {
            return Container();
          } else {
            controller.defaultTransactionList[index] =
                controller.defaultTransactionList[index].copyWith(
                    isNft: true,
                    tokenSymbol: snapshot.data!.fa!.name.toString(),
                    dollarAmount: (snapshot.data!.lowestAsk == null
                            ? 0
                            : (snapshot.data!.lowestAsk / 1e6)) *
                        controller.accController.xtzPrice.value,
                    tokenAmount: snapshot.data!.lowestAsk != null &&
                            snapshot.data!.lowestAsk != 0
                        ? snapshot.data!.lowestAsk / 1e6
                        : 0,
                    name: snapshot.data!.name.toString(),
                    imageUrl: snapshot.data!.displayUri);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.defaultTransactionList[index].timeStamp!.isSameMonth(
                        controller
                            .defaultTransactionList[index == 0 ? 0 : index - 1]
                            .timeStamp!)
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(
                            top: 16.arP, left: 16.arP, bottom: 16.arP),
                        child: Text(
                          DateFormat.MMMM()
                              // displaying formatted date
                              .format(controller
                                  .defaultTransactionList[index].timeStamp!),
                          style: labelLarge,
                        ),
                      ),
                HistoryTile(
                  tokenInfo: controller.defaultTransactionList[index],
                  xtzPrice: controller.accController.xtzPrice.value,
                  onTap: () => CommonFunctions.bottomSheet(
                    TransactionDetailsBottomSheet(
                      xtzPrice: controller.accController.xtzPrice.value,
                      tokenInfo: controller.defaultTransactionList[index],
                      userAccountAddress: controller
                          .accController.selectedAccount.value.publicKeyHash!,
                    ),
                  ),
                ),
              ],
            );
          }
        }));
  }
}
