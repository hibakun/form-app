// To parse this JSON data, do
//
//     final surveyFormDownloadModel = surveyFormDownloadModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SurveyFormDownloadModel surveyFormDownloadModelFromJson(String str) =>
    SurveyFormDownloadModel.fromJson(json.decode(str));

String surveyFormDownloadModelToJson(SurveyFormDownloadModel data) =>
    json.encode(data.toJson());

class SurveyFormDownloadModel {
  SurveyFormDownloadModel({
    required this.status,
    required this.messages,
    required this.data,
  });

  String status;
  List<String> messages;
  SurveyFormDownloadData data;

  factory SurveyFormDownloadModel.fromJson(Map<String, dynamic> json) =>
      SurveyFormDownloadModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        data: SurveyFormDownloadData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "data": data.toJson(),
      };
}

class SurveyFormDownloadData {
  SurveyFormDownloadData({
    required this.surveyTable,
    required this.surveyLines,
  });

  SurveyTable surveyTable;
  List<SurveyLine> surveyLines;

  factory SurveyFormDownloadData.fromJson(Map<String, dynamic> json) =>
      SurveyFormDownloadData(
        surveyTable: SurveyTable.fromJson(json["surveyTable"]),
        surveyLines: List<SurveyLine>.from(
            json["surveyLines"].map((x) => SurveyLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "surveyTable": surveyTable.toJson(),
        "surveyLines": List<dynamic>.from(surveyLines.map((x) => x.toJson())),
      };
}

class SurveyLine {
  SurveyLine({
    required this.dtoFormLine,
    required this.userInput,
    required this.transTime,
  });

  DtoFormLine dtoFormLine;
  String userInput;
  String transTime;

  factory SurveyLine.fromJson(Map<String, dynamic> json) => SurveyLine(
        dtoFormLine: DtoFormLine.fromJson(json["dtoFormLine"]),
        userInput: json["userInput"],
        transTime: json["transTime"],
      );

  Map<String, dynamic> toJson() => {
        "dtoFormLine": dtoFormLine.toJson(),
        "userInput": userInput,
        "transTime": transTime,
      };
}

class DtoFormLine {
  DtoFormLine({
    required this.id,
    required this.inputType,
    required this.question,
    required this.dropDown,
  });

  int id;
  String inputType;
  String question;
  String dropDown;

  factory DtoFormLine.fromJson(Map<String, dynamic> json) => DtoFormLine(
        id: json["id"],
        inputType: json["inputType"],
        question: json["question"],
        dropDown: json["dropDown"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inputType": inputType,
        "question": question,
        "dropDown": dropDown,
      };
}

class SurveyTable {
  SurveyTable({
    required this.transId,
    required this.title,
    required this.description,
    required this.transDate,
    required this.name,
    required this.birthDate,
    required this.formType,
    required this.municipality,
    required this.subDistrict,
    required this.village,
    required this.subVillage,
    required this.interviewerName,
    required this.transTime,
    required this.deviceId,
    required this.villageHeadName,
  });

  String transId;
  String title;
  String description;
  String transDate;
  String name;
  String birthDate;
  String formType;
  int municipality;
  int subDistrict;
  int village;
  int subVillage;
  String interviewerName;
  String transTime;
  String deviceId;
  String villageHeadName;

  factory SurveyTable.fromJson(Map<String, dynamic> json) => SurveyTable(
        transId: json["transId"],
        title: json["title"],
        description: json["description"],
        transDate: json["transDate"],
        name: json["name"],
        birthDate: json["birthDate"],
        formType: json["formType"],
        municipality: json["municipality"],
        subDistrict: json["subDistrict"],
        village: json["village"],
        subVillage: json["subVillage"],
        interviewerName: json["interviewerName"],
        transTime: json["transTime"],
        deviceId: json["deviceId"],
        villageHeadName: json["villageHeadName"],
      );

  Map<String, dynamic> toJson() => {
        "transId": transId,
        "title": title,
        "description": description,
        "transDate": transDate,
        "name": name,
        "birthDate": birthDate,
        "formType": formType,
        "municipality": municipality,
        "subDistrict": subDistrict,
        "village": village,
        "subVillage": subVillage,
        "interviewerName": interviewerName,
        "transTime": transTime,
        "deviceId": deviceId,
        "villageHeadName": villageHeadName,
      };
}
