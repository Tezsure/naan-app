import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({Key? key}) : super(key: key);

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        expanded
            ? Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: ListView.separated(
                    itemBuilder: (context, index) => accountWidget(),
                    separatorBuilder: (context, index) => const Divider(
                        color: Color(0xff4a454e), height: 1, thickness: 1),
                    itemCount: 100,
                    shrinkWrap: true,
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        4,
                        (index) => accountWidget(),
                      ),
                    ),
                    if (!expanded)
                      Column(
                        children: [
                          const Divider(
                            color: Color(0xff4a454e),
                            height: 1,
                            thickness: 1,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expanded = true;
                              });
                            },
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Show more accounts",
                                  style: labelMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
        if (!expanded) const Spacer()
      ],
    );
  }

  Widget accountWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 84,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
          ),
          20.hspace,
          RichText(
            text: TextSpan(
              text: "tz1...qfDZg\n",
              style: bodySmall,
              children: [
                WidgetSpan(child: 0.035.height.vspace),
                TextSpan(
                  text: "20 tez",
                  style: bodyLarge,
                )
              ],
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(Colors.white),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
          )
        ],
      ),
    );
  }
}
