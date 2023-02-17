import 'dart:convert';
import 'dart:math';

import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:simple_gql/simple_gql.dart';

import '../service_config/service_config.dart';

class ArtFoundationHandler {
  static Future<NftTokenModel?> getCollectionNfts(String pkH) async {
    try {
      final response = await GQLClient(
        'https://data.objkt.com/v3/graphql',
      ).query(
        query: ServiceConfig.collectionQuery,
        variables: {'address': pkH},
      );

      // final r= jsonEncode(
      //     response.data['token'].where((e) => e['token_id'] != "").toList());
      int length = response.data['token'].length;
      int index = Random().nextInt(length - 1);
      return NftTokenModel.fromJson(response.data['token'][index]);
    } catch (e) {
      print(" gql error $e");
      return NftTokenModel(artifactUri: "");
    }
  }
}
