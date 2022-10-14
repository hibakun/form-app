// To parse this JSON data, do
//
//     final villageLikeModel = villageLikeModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VillageLikeModel villageLikeModelFromJson(String str) =>
    VillageLikeModel.fromJson(json.decode(str));

String villageLikeModelToJson(VillageLikeModel data) =>
    json.encode(data.toJson());

class VillageLikeModel {
  VillageLikeModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<VillageLikeData> data;

  factory VillageLikeModel.fromJson(Map<String, dynamic> json) =>
      VillageLikeModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<VillageLikeData>.from(
            json["data"].map((x) => VillageLikeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class VillageLikeData {
  VillageLikeData({
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
  VillageLikeData? subDistrict;
  VillageLikeData? municipality;

  factory VillageLikeData.fromJson(Map<String, dynamic> json) =>
      VillageLikeData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        subDistrict: json["subDistrict"] == null
            ? null
            : VillageLikeData.fromJson(json["subDistrict"]),
        municipality: json["municipality"] == null
            ? null
            : VillageLikeData.fromJson(json["municipality"]),
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
