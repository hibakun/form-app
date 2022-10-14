// To parse this JSON data, do
//
//     final subvillageModel = subvillageModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubvillageModel subvillageModelFromJson(String str) =>
    SubvillageModel.fromJson(json.decode(str));

String subvillageModelToJson(SubvillageModel data) =>
    json.encode(data.toJson());

class SubvillageModel {
  SubvillageModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<SubvillageData> data;

  factory SubvillageModel.fromJson(Map<String, dynamic> json) =>
      SubvillageModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<SubvillageData>.from(
            json["data"].map((x) => SubvillageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SubvillageData {
  SubvillageData({
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
  SubvillageData? village;
  SubvillageData? subDistrict;
  SubvillageData? municipality;

  factory SubvillageData.fromJson(Map<String, dynamic> json) => SubvillageData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        village: json["village"] == null
            ? null
            : SubvillageData.fromJson(json["village"]),
        subDistrict: json["subDistrict"] == null
            ? null
            : SubvillageData.fromJson(json["subDistrict"]),
        municipality: json["municipality"] == null
            ? null
            : SubvillageData.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "village": village == null ? null : village!.toJson(),
        "subDistrict": subDistrict == null ? null : subDistrict!.toJson(),
        "municipality": municipality == null ? null : municipality!.toJson(),
      };
}
