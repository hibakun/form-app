// To parse this JSON data, do
//
//     final subdisctrictByMuniModel = subdisctrictByMuniModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubdisctrictByMuniModel subdisctrictByMuniModelFromJson(String str) =>
    SubdisctrictByMuniModel.fromJson(json.decode(str));

String subdisctrictByMuniModelToJson(SubdisctrictByMuniModel data) =>
    json.encode(data.toJson());

class SubdisctrictByMuniModel {
  SubdisctrictByMuniModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<SubdisctrictByMuniData> data;

  factory SubdisctrictByMuniModel.fromJson(Map<String, dynamic> json) =>
      SubdisctrictByMuniModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<SubdisctrictByMuniData>.from(
            json["data"].map((x) => SubdisctrictByMuniData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SubdisctrictByMuniData {
  SubdisctrictByMuniData({
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
  SubdisctrictByMuniData? municipality;

  factory SubdisctrictByMuniData.fromJson(Map<String, dynamic> json) =>
      SubdisctrictByMuniData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        municipality: json["municipality"] == null
            ? null
            : SubdisctrictByMuniData.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "municipality": municipality == null ? null : municipality!.toJson(),
      };
}
