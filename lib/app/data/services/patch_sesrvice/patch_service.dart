import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

class PatchService {
  Future<List<AccountModel>> recoverWalletsFromOldStorage() async {
    var oldStorage = await ServiceConfig.localStorage
        .read(key: ServiceConfig.oldStorageName);
    if (oldStorage != null && oldStorage.isNotEmpty) {
      oldStorage = _decryptString(oldStorage);
      var accounts = jsonDecode(oldStorage)['accounts']['mainnet'];
      List<AccountModel> accountList = [];
      for (var account in accounts) {
        accountList.add(AccountModel(
          name: account["name"],
          imageType: AccountProfileImageType.assets,
          profileImage: ServiceConfig.allAssetsProfileImages[
              Random().nextInt(ServiceConfig.allAssetsProfileImages.length)],
          publicKeyHash: account["publicKeyHash"],
          isNaanAccount: account.containsKey("isNaanWallet")
              ? account["isNaanWallet"]
              : false,
        )..accountSecretModel = AccountSecretModel(
            seedPhrase: account.containsKey("seed") ? account["seed"] : null,
            publicKey: account["publicKey"],
            secretKey: account["secretKey"],
            derivationPathIndex: account["derivationPath"].isEmpty
                ? 0
                : int.parse(
                    account["derivationPath"]
                        .split("/")[2]
                        .toString()
                        .replaceAll("'", ""),
                  )));
      }
      return accountList;
    }
    return <AccountModel>[];
  }

  String _decryptString(var text) {
    var data = '';
    text = text.split(' ');
    for (var i = 0; (i < text.length); i++) {
      data += String.fromCharCode(int.parse(text[i]) - 2);
    }
    return data;
  }
}