// To parse this JSON data, do
//
//     final villageBySubModel = villageBySubModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VillageBySubModel villageBySubModelFromJson(String str) =>
    VillageBySubModel.fromJson(json.decode(str));

String villageBySubModelToJson(VillageBySubModel data) =>
    json.encode(data.toJson());

class VillageBySubModel {
  VillageBySubModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<VillageBySubData> data;

  factory VillageBySubModel.fromJson(Map<String, dynamic> json) =>
      VillageBySubModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<VillageBySubData>.from(
            json["data"].map((x) => VillageBySubData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class VillageBySubData {
  VillageBySubData({
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
  VillageBySubData? subDistrict;
  VillageBySubData? municipality;

  factory VillageBySubData.fromJson(Map<String, dynamic> json) =>
      VillageBySubData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        subDistrict: json["subDistrict"] == null
            ? null
            : VillageBySubData.fromJson(json["subDistrict"]),
        municipality: json["municipality"] == null
            ? null
            : VillageBySubData.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "subDistrict": subDistrict == null ? null : subDistrict!.toJson(),
        "municipality": municipality == null ? null : municipality!.toJson(),
      };
}
