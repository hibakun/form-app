// To parse this JSON data, do
//
//     final subdisctrictLikeModel = subdisctrictLikeModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubdisctrictLikeModel subdisctrictLikeModelFromJson(String str) =>
    SubdisctrictLikeModel.fromJson(json.decode(str));

String subdisctrictLikeModelToJson(SubdisctrictLikeModel data) =>
    json.encode(data.toJson());

class SubdisctrictLikeModel {
  SubdisctrictLikeModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<SubdisctrictLikeData> data;

  factory SubdisctrictLikeModel.fromJson(Map<String, dynamic> json) =>
      SubdisctrictLikeModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<SubdisctrictLikeData>.from(
            json["data"].map((x) => SubdisctrictLikeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SubdisctrictLikeData {
  SubdisctrictLikeData({
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
  SubdisctrictLikeData? municipality;

  factory SubdisctrictLikeData.fromJson(Map<String, dynamic> json) =>
      SubdisctrictLikeData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        municipality: json["municipality"] == null
            ? null
            : SubdisctrictLikeData.fromJson(json["municipality"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "municipality": municipality == null ? null : municipality!.toJson(),
      };
}
