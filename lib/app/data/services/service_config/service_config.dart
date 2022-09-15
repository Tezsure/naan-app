import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class ServiceConfig {
  /// Current selected node
  static String currentSelectedNode =
      "https://tezos-prod.cryptonomic-infra.tech:443";

  /// Teztools api with endpoint for mainnet token prices
  static String tezToolsApi = "https://api.teztools.io/token/prices";

  /// Xtz price coingecko api with endpoint
  static String coingeckoApi =
      "https://api.coingecko.com/api/v3/simple/price?ids=tezos&vs_currencies=usd";

  static String tzktApiForToken(String pkh) =>
      "https://api.tzkt.io/v1/tokens/balances?account=$pkh&balance.ne=0&limit=10000&token.metadata.tags.null=true&token.metadata.creators.null=true&token.metadata.artifactUri.null=true";

  // Main storage keys
  static const String oldStorageName = "tezsure-wallet-storage-v1.0.0";
  static const String storageName = "naan_wallet_version_2.0.0";

  // Accounts storage keys
  static const String accountsStorage = "${storageName}_accounts_storage";

  /// append with publicKeyHash while saving or reading
  static const String accountTokensStorage =
      "${storageName}_account_tokens_storage";
  // static const String accountsSecretStorage =
  //     "${storageName}_accounts_secret_storage";
  static const String watchAccountsStorage =
      "${storageName}_gallery_accounts_storage";

  // auth
  static const String passCodeStorage = "${storageName}_password";
  static const String biometricAuthStorage = "${storageName}_biometricAuth";

  // xtz price and token price
  static const String xtzPrice = "${storageName}_xtz_price";
  static const String tokenPrices = "${storageName}_token_prices";

  // user xtz balances, token balances and nfts
  // static const String accountXtzBalances =
  //     "${storageName}_account_xtz_balances";

  /// Flutter Secure Storage instance </br>
  /// Android it uses keyStore to encrypt the data </br>
  /// Ios it uses Keychain to encrypt the data
  static const FlutterSecureStorage localStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const List<String> allAssetsProfileImages = <String>[
    "${PathConst.PROFILE_IMAGES}1.png",
    "${PathConst.PROFILE_IMAGES}2.png",
    "${PathConst.PROFILE_IMAGES}3.png",
    "${PathConst.PROFILE_IMAGES}4.png",
    "${PathConst.PROFILE_IMAGES}5.png",
    "${PathConst.PROFILE_IMAGES}6.png",
    "${PathConst.PROFILE_IMAGES}7.png",
    "${PathConst.PROFILE_IMAGES}8.png",
    "${PathConst.PROFILE_IMAGES}9.png",
    "${PathConst.PROFILE_IMAGES}10.png",
    "${PathConst.PROFILE_IMAGES}11.png",
  ];

  /// Clear the local storage
  Future<void> clearStorage() async {
    await localStorage.deleteAll();
  }
}