// To parse this JSON data, do
//
//     final subdisctrictModel = subdisctrictModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubdisctrictModel subdisctrictModelFromJson(String str) =>
    SubdisctrictModel.fromJson(json.decode(str));

String subdisctrictModelToJson(SubdisctrictModel data) =>
    json.encode(data.toJson());

class SubdisctrictModel {
  SubdisctrictModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<SubdisctrictData> data;

  factory SubdisctrictModel.fromJson(Map<String, dynamic> json) =>
      SubdisctrictModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<SubdisctrictData>.from(
            json["data"].map((x) => SubdisctrictData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SubdisctrictData {
  SubdisctrictData({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.municipality,
  });

  int id;
  String code;
  String name;
  String description;
  SubdisctrictData? municipality;

  factory SubdisctrictData.fromJson(Map<String, dynamic> json) =>
      SubdisctrictData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        municipality: json["municipality"] == null
            ? null
            : SubdisctrictData.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "municipality": municipality == null ? null : municipality!.toJson(),
      };
}
