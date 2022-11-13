// To parse this JSON data, do
//
//     final villageModel = villageModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VillageModel villageModelFromJson(String str) =>
    VillageModel.fromJson(json.decode(str));

String villageModelToJson(VillageModel data) => json.encode(data.toJson());

class VillageModel {
  VillageModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<VillageData> data;

  factory VillageModel.fromJson(Map<String, dynamic> json) => VillageModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<VillageData>.from(
            json["data"].map((x) => VillageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class VillageData {
  VillageData({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.subDistrict,
    required this.municipality,
  });

  int id;
  String code;
  String name;
  String description;
  VillageData? subDistrict;
  VillageData? municipality;

  factory VillageData.fromJson(Map<String, dynamic> json) => VillageData(
        id: json["id"],
        code: json["code"],
        name: utf8.decode(json["name"].runes.toList()),
        description: json["description"],
        subDistrict: json["subDistrict"] == null
            ? null
            : VillageData.fromJson(json["subDistrict"]),
        municipality: json["municipality"] == null
            ? null
            : VillageData.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": utf8.decode(name.runes.toList()),
        "description": description,
        "subDistrict": subDistrict == null ? null : subDistrict!.toJson(),
        "municipality": municipality == null ? null : municipality!.toJson(),
      };
}
