import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:naan_wallet/app/data/services/extension_service/extension_service.dart';
import '../../../../utils/styles/styles.dart';

class AccountWidget extends StatelessWidget {
  AccountWidget({Key? key}) : super(key: key);

  final ImportWalletPageController controller =
      Get.find<ImportWalletPageController>();

  Map<String, double> accountBalances = <String, double>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Visibility(
              visible: controller.isExpanded.isTrue,
              replacement: Container(
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
                        controller.generatedAccounts.length,
                        (index) => accountWidget(
                            controller.generatedAccounts[index], index),
                      ),
                    ),
                    if (controller.generatedAccounts.length < 100)
                      showMoreAccountButton(
                          controller.generatedAccounts.length - 1),
                  ],
                ),
              ),
              child: Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => accountWidget(
                              controller.generatedAccounts[index], index),
                          separatorBuilder: (context, index) => const Divider(
                              color: Color(0xff4a454e),
                              height: 1,
                              thickness: 1),
                          itemCount: controller.generatedAccounts.length,
                          shrinkWrap: true,
                        ),
                      ),
                      if (controller.generatedAccounts.length < 100)
                        showMoreAccountButton(
                            controller.generatedAccounts.length - 1),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Column showMoreAccountButton(int index) {
    return Column(
      children: [
        const Divider(
          color: Color(0xff4a454e),
          height: 1,
          thickness: 1,
        ),
        GestureDetector(
          onTap: () {
            controller.genAndLoadMoreAccounts(index, 3);

            // controller.showMoreAccounts();
            controller.isExpanded.value = true;
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
    );
  }

  Widget accountWidget(AccountModel accountModel, index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 84,
      child: Row(
        children: [
          Container(
            height: 0.13.width,
            width: 0.13.width,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(accountModel.profileImage!),
              ),
            ),
          ),
          0.05.hspace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tz1Shortner(accountModel.publicKeyHash!),
                style: bodySmall,
              ),
              accountBalances.containsKey(accountModel.publicKeyHash)
                  ? Text(
                      "${accountBalances[accountModel.publicKeyHash]} tez",
                      style: bodyLarge,
                    )
                  : FutureBuilder<double>(
                      future: accountModel.getUserBalanceInTezos(),
                      initialData: 0.0,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        accountBalances[accountModel.publicKeyHash!] =
                            snapshot.data;
                        return Text(
                          "${snapshot.data} tez",
                          style: bodyLarge,
                        );
                      },
                    ),
            ],
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: Checkbox(
              value: controller.selectedAccounts.contains(accountModel),
              onChanged: (value) {
                if (value!) {
                  controller.selectedAccounts.add(accountModel);
                } else {
                  controller.selectedAccounts.remove(accountModel);
                }
              },
              checkColor: Colors.black,
              fillColor: MaterialStateProperty.all(Colors.white),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
          )
        ],
      ),
    );
  }
}
