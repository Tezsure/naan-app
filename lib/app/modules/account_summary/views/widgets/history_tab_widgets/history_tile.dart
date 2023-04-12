import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/veNFT.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../models/token_info.dart';

class HistoryTile extends StatefulWidget {
  final VoidCallback? onTap;
  final double xtzPrice;
  final TokenInfo tokenInfo;

  const HistoryTile({
    super.key,
    this.onTap,
    required this.xtzPrice,
    required this.tokenInfo,
  });

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: widget.onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 16.arP, right: 16.arP, bottom: 10.arP),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.arP),
          ),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: SizedBox(
            // height: 61.arP,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 12.arP, right: 12.arP, top: 12.arP, bottom: 12.arP),
              child: Column(
                children: [
                  // Text((widget.tokenInfo.token?.hash ?? "").tz1Short()),
                  _buildBody(widget.tokenInfo),
                  ...widget.tokenInfo.internalOperation.map((e) => Padding(
                        padding: EdgeInsets.only(top: 20.arP),
                        child: _buildBody(e),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadNFTTransaction(TokenInfo data) {
    return FutureBuilder(
        key: Key(data.nftContractAddress! + data.nftTokenId!),
        future: ObjktNftApiService()
            .getTransactionNFT(data.nftContractAddress!, data.nftTokenId!),
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
            data = data.copyWith(
                isNft: true,
                tokenSymbol: snapshot.data!.fa!.name.toString(),
                dollarAmount: (snapshot.data!.lowestAsk == null
                        ? 0
                        : (snapshot.data!.lowestAsk / 1e6)) *
                    widget.xtzPrice,
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
                _buildBody(
                  data,
                ),
              ],
            );
          }
        }));
  }

  Widget _buildBody(TokenInfo data) {
    final selectedAccount = Get.find<HomePageController>()
        .userAccounts[Get.find<HomePageController>().selectedIndex.value]
        .publicKeyHash!;
    final tokenList = Get.find<AccountSummaryController>().tokensList;
    if (data.token == null) {
      if (data.name.isEmpty) {
        return _loadNFTTransaction(data);
      }
    } else {
      final transactionInterface = data.token!.transactionInterface(tokenList);

      if (!data.token!.isNFTTx(tokenList)) {
        data = data.copyWith(
          imageUrl: transactionInterface.imageUrl,
          name: transactionInterface.name,
          tokenAmount: data.token!.getAmount(
            tokenList,
            selectedAccount,
          ),
        );
        data = data.copyWith(
            dollarAmount: transactionInterface.rate! *
                widget.xtzPrice *
                data.tokenAmount);
      } else {
        if (data.name.isEmpty) {
          data = data.copyWith(
              nftTokenId: transactionInterface.tokenID,
              address: transactionInterface.contractAddress);
          return _loadNFTTransaction(data);
        }
      }
    }

    // if (data.name == "Tezos" && data.tokenAmount == 0.0) return Container();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.arP,
          backgroundColor: Colors.black,
          child: data.imageUrl.startsWith("assets")
              ? data.imageUrl.endsWith(".svg")
                  ? SvgPicture.asset(
                      data.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      data.imageUrl,
                      cacheHeight: 82,
                      cacheWidth: 82,
                      fit: BoxFit.cover,
                    )
              : data.imageUrl.endsWith(".svg")
                  ? SvgPicture.network(
                      data.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: data.isNft
                            ? Border.all(
                                width: 1.5.arP,
                                color: ColorConst.NeutralVariant.shade60,
                              )
                            : const Border(),
                      ),
                      child: ClipOval(
                        child: data.nftContractAddress ==
                                "KT18kkvmUoefkdok5mrjU6fxsm7xmumy1NEw"
                            ? VeNFT(url: data.imageUrl)
                            : CachedNetworkImage(
                                imageUrl: data.imageUrl.startsWith("ipfs")
                                    ? "https://ipfs.io/ipfs/${data.imageUrl.replaceAll("ipfs://", '')}"
                                    : data.imageUrl,
                                memCacheHeight: 82,
                                memCacheWidth: 82,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
        ),
        SizedBox(
          width: 12.arP,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                    data.token?.getTxIcon(selectedAccount) ??
                        "assets/transaction/down.png",
                    width: 14.arP,
                    height: 14.arP,
                    color: data.internalOperation.isNotEmpty
                        ? ColorConst.Primary
                        : ColorConst.NeutralVariant.shade60),
                Text(" ${data.token?.getTxType(selectedAccount) ?? "Received"}",
                    maxLines: 1,
                    style: labelMedium.copyWith(
                        color: data.internalOperation.isNotEmpty
                            ? ColorConst.Primary
                            : ColorConst.NeutralVariant.shade60,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(
              height: 4.arP,
            ),
            SizedBox(
              width: 180.arP,
              child: Text(
                data.name,
                style: labelLarge.copyWith(
                    letterSpacing: 0.5, fontWeight: FontWeight.w400),
                softWrap: false,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  data.isNft
                      ? "${data.tokenAmount.toStringAsFixed(0)} ${data.tokenSymbol}"
                      : "${data.tokenAmount.toStringAsFixed(6)} ${data.tokenSymbol}",
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60)),
              SizedBox(
                height: 4.arP,
              ),
              Text(
                data.token == null || data.token?.operationStatus == 'applied'
                    ? getColor(data.token, selectedAccount) ==
                            ColorConst.NaanRed
                        ? '- ${(data.dollarAmount).roundUpDollar(widget.xtzPrice)}'
                        : (data.dollarAmount).roundUpDollar(widget.xtzPrice)
                    : "failed",
                style: labelLarge.copyWith(
                    fontWeight: FontWeight.w400,
                    color: data.token == null ||
                            data.token?.operationStatus == 'applied'
                        ? getColor(data.token, selectedAccount)
                        : ColorConst.NaanRed),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        )),
      ],
    );
  }

  Color getColor(TxHistoryModel? data, String selectedAccount) {
    if (data == null) return ColorConst.naanCustomColor;
    if (data.isSent(selectedAccount)) {
      return ColorConst.NaanRed;
    }
    if (data.isReceived(selectedAccount)) {
      return ColorConst.naanCustomColor;
    }
    if (data.getTxType(selectedAccount) == "Contract interaction" &&
        (data.amount ?? 0) > 0 &&
        data.sender!.address == selectedAccount) {
      return ColorConst.NaanRed;
    }
    return Colors.white;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
