// To parse this JSON data, do
//
//     final delegateBakersListResponse = delegateBakersListResponseFromJson(jsonString);

import 'dart:convert';

List<DelegateBakerModel> delegateBakersListResponseFromJson(String str) =>
    List<DelegateBakerModel>.from(
        json.decode(str).map((x) => DelegateBakerModel.fromJson(x)));

String delegateBakersListResponseToJson(List<DelegateBakerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DelegateBakerModel {
  DelegateBakerModel({
    this.rank,
    this.logo,
    this.logoMin,
    this.name,
    this.address,
    this.fee,
    this.lifetime,
    this.delegateBakersListResponseYield,
    this.efficiency,
    this.efficiencyLast10Cycle,
    this.freespace,
    this.totalPoints,
    this.deletationStatus,
    this.freespaceMin,
    this.proStatus,
  });

  int? rank;
  String? logo;
  String? logoMin;
  String? name;
  String? address;
  double? fee;
  int? lifetime;
  double? delegateBakersListResponseYield;
  double? efficiency;
  double? efficiencyLast10Cycle;
  int? freespace;
  int? totalPoints;
  bool? deletationStatus;
  String? freespaceMin;
  bool? proStatus;

  DelegateBakerModel copyWith({
    int? rank,
    String? logo,
    String? logoMin,
    String? name,
    String? address,
    double? fee,
    int? lifetime,
    double? delegateBakersListResponseYield,
    double? efficiency,
    double? efficiencyLast10Cycle,
    int? freespace,
    int? totalPoints,
    bool? deletationStatus,
    String? freespaceMin,
    bool? proStatus,
  }) =>
      DelegateBakerModel(
        rank: rank ?? this.rank,
        logo: logo ?? this.logo,
        logoMin: logoMin ?? this.logoMin,
        name: name ?? this.name,
        address: address ?? this.address,
        fee: fee ?? this.fee,
        lifetime: lifetime ?? this.lifetime,
        delegateBakersListResponseYield: delegateBakersListResponseYield ??
            this.delegateBakersListResponseYield,
        efficiency: efficiency ?? this.efficiency,
        efficiencyLast10Cycle:
            efficiencyLast10Cycle ?? this.efficiencyLast10Cycle,
        freespace: freespace ?? this.freespace,
        totalPoints: totalPoints ?? this.totalPoints,
        deletationStatus: deletationStatus ?? this.deletationStatus,
        freespaceMin: freespaceMin ?? this.freespaceMin,
        proStatus: proStatus ?? this.proStatus,
      );

  factory DelegateBakerModel.fromJson(Map<String, dynamic> json) =>
      DelegateBakerModel(
        rank: json["rank"],
        logo: json["logo"],
        logoMin: json["logo_min"],
        name: json["name"],
        address: json["address"],
        fee: json["fee"].toDouble(),
        lifetime: json["lifetime"],
        delegateBakersListResponseYield: json["yield"].toDouble(),
        efficiency: json["efficiency"].toDouble(),
        efficiencyLast10Cycle: json["efficiency_last10cycle"].toDouble(),
        freespace: json["freespace"],
        totalPoints: json["total_points"],
        deletationStatus: json["deletation_status"],
        freespaceMin: json["freespace_min"],
        proStatus: json["pro_status"],
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "logo": logo,
        "logo_min": logoMin,
        "name": name,
        "address": address,
        "fee": fee,
        "lifetime": lifetime,
        "yield": delegateBakersListResponseYield,
        "efficiency": efficiency,
        "efficiency_last10cycle": efficiencyLast10Cycle,
        "freespace": freespace,
        "total_points": totalPoints,
        "deletation_status": deletationStatus,
        "freespace_min": freespaceMin,
        "pro_status": proStatus,
      };
}
