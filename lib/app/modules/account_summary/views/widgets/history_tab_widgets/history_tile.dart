import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
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
                  left: 12.arP, right: 9.arP, top: 10.arP, bottom: 10.arP),
              child: Column(
                children: [
                  // Text((widget.tokenInfo.token?.hash ?? "").tz1Short()),
                  _buildBody(widget.tokenInfo),
                  ...widget.tokenInfo.internalOperation.map((e) => Padding(
                        padding: EdgeInsets.only(top: 8.0.arP),
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

  Row _buildBody(TokenInfo data) {
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
                        child: CachedNetworkImage(
                          imageUrl: data.imageUrl.startsWith("ipfs")
                              ? "https://ipfs.io/ipfs/${widget.tokenInfo.imageUrl.replaceAll("ipfs://", '')}"
                              : widget.tokenInfo.imageUrl,
                          memCacheHeight: 82,
                          memCacheWidth: 82,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
        ),
        0.02.hspace,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(data.isSent ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14.arP,
                    color: data.internalOperation.isNotEmpty
                        ? ColorConst.Primary
                        : ColorConst.NeutralVariant.shade60),
                Text(" ${data.token?.actionType ?? ""}",
                    style: labelMedium.copyWith(
                        color: data.internalOperation.isNotEmpty
                            ? ColorConst.Primary
                            : ColorConst.NeutralVariant.shade60,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.arP),
              child: SizedBox(
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
                      ? data.tokenSymbol
                      : "${data.tokenAmount.toStringAsFixed(6)} ${data.tokenSymbol}",
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60)),
              Text(
                data.token!.operationStatus == 'applied'
                    ? data.tokenSymbol == "tez"
                        ? data.isSent
                            ? '- ${(data.dollarAmount).roundUpDollar(widget.xtzPrice)}'
                            : (data.dollarAmount).roundUpDollar(widget.xtzPrice)
                        : ""
                    : "failed",
                style: labelLarge.copyWith(
                    fontWeight: FontWeight.w400,
                    color: data.token!.operationStatus == 'applied'
                        ? data.isSent
                            ? Colors.white
                            : ColorConst.naanCustomColor
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
