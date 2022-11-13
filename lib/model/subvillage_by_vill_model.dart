// To parse this JSON data, do
//
//     final subvillageByVill = subvillageByVillFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubvillageByVillModel subvillageByVillFromJson(String str) =>
    SubvillageByVillModel.fromJson(json.decode(str));

String subvillageByVillToJson(SubvillageByVillModel data) =>
    json.encode(data.toJson());

class SubvillageByVillModel {
  SubvillageByVillModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<SubvillageByVillageData> data;

  factory SubvillageByVillModel.fromJson(Map<String, dynamic> json) =>
      SubvillageByVillModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<SubvillageByVillageData>.from(
            json["data"].map((x) => SubvillageByVillageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SubvillageByVillageData {
  SubvillageByVillageData({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.village,
    required this.subDistrict,
    required this.municipality,
  });

  int id;
  String code;
  String name;
  String description;
  SubvillageByVillageData? village;
  SubvillageByVillageData? subDistrict;
  SubvillageByVillageData? municipality;

  factory SubvillageByVillageData.fromJson(Map<String, dynamic> json) =>
      SubvillageByVillageData(
        id: json["id"],
        code: json["code"],
        name: utf8.decode(json["name"].runes.toList()),
        description: json["description"],
        village: json["village"] == null
            ? null
            : SubvillageByVillageData.fromJson(json["village"]),
        subDistrict: json["subDistrict"] == null
            ? null
            : SubvillageByVillageData.fromJson(json["subDistrict"]),
        municipality: json["municipality"] == null
            ? null
            : SubvillageByVillageData.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": utf8.decode(name.runes.toList()),
        "description": description,
        "village": village == null ? null : village!.toJson(),
        "subDistrict": subDistrict == null ? null : subDistrict!.toJson(),
        "municipality": municipality == null ? null : municipality!.toJson(),
      };
}
