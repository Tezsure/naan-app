// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:plenty_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
// import 'package:plenty_wallet/utils/extensions/size_extension.dart';

// import '../../../../../../utils/colors/colors.dart';
// import '../../../../../../utils/styles/styles.dart';
// import '../../../../common_widgets/solid_button.dart';
// import '../../../../home_page/widgets/delegate_widget/widgets/delegate_baker.dart';

// class ReDelegateHeader extends StatelessWidget {
//     final DelegateBakerModel baker;
//   const ReDelegateHeader({super.key, required this.baker});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: const Color(0xff958e99).withOpacity(0.2),
//         border: Border.all(
//           color: Colors.transparent,
//           width: 2,
//         ),
//       ),
//       padding:
//           EdgeInsets.symmetric(horizontal: 0.04.width, vertical: 0.01.height),
//       margin: EdgeInsets.symmetric(vertical: 0.02.height),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.transparent,
//                 radius: 20,
//                 child: Image.asset(
//                   'assets/temp/delegate_baker.png',
//                   fit: BoxFit.cover,
//                   width: 40.arP,
//                   height: 40.arP,
//                 ),
//               ),
//               0.02.hspace,
//               RichText(
//                   text: TextSpan(
//                       text: 'MyTezosBaking\n',
//                       style: labelMedium,
//                       children: [
//                     TextSpan(
//                       text: 'tz1d6....pVok8',
//                       style: labelSmall.copyWith(color: ColorConst.Primary),
//                     ),
//                     WidgetSpan(
//                       alignment: PlaceholderAlignment.middle,
//                       child: IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.copy,
//                           color: ColorConst.Primary,
//                           size: 10,
//                         ),
//                         iconSize: 10,
//                         constraints: const BoxConstraints(),
//                       ),
//                     ),
//                   ])),
//               const Spacer(),
//               SolidButton(
//                 height: 0.03.height,
//                 width: 0.24.width,
//                 child: Text('Redelegate', style: labelSmall),
//                 onPressed: () => Get.bottomSheet(
//                         DelegateSelectBaker(
//                           isScrollable: true,
//                         ),
//                         enableDrag: true,
//                         isScrollControlled: true)
//                     .whenComplete(() => Get.back()),
//               ),
//             ],
//           ),
//           0.013.vspace,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               RichText(
//                 textAlign: TextAlign.start,
//                 text: TextSpan(
//                   text: 'Baker fee:\n',
//                   style: labelSmall.copyWith(
//                       color: ColorConst.NeutralVariant.shade70),
//                   children: [TextSpan(text: '14%', style: labelLarge)],
//                 ),
//               ),
//               0.12.hspace,
//               RichText(
//                 textAlign: TextAlign.start,
//                 text: TextSpan(
//                   text: 'Staking:\n',
//                   style: labelSmall.copyWith(
//                       color: ColorConst.NeutralVariant.shade70),
//                   children: [TextSpan(text: '116K', style: labelLarge)],
//                 ),
//               ),
//               0.12.hspace,
//               RichText(
//                 textAlign: TextAlign.start,
//                 text: TextSpan(
//                   text: 'Payout:\n',
//                   style: labelSmall.copyWith(
//                       color: ColorConst.NeutralVariant.shade70),
//                   children: [TextSpan(text: '30 Days', style: labelLarge)],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
