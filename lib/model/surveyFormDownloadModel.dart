// To parse this JSON data, do
//
//     final surveyFormDownloadModel = surveyFormDownloadModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SurveyFormDownloadModel surveyFormDownloadModelFromJson(String str) => SurveyFormDownloadModel.fromJson(json.decode(str));

String surveyFormDownloadModelToJson(SurveyFormDownloadModel data) => json.encode(data.toJson());

class SurveyFormDownloadModel {
  SurveyFormDownloadModel({
    required this.status,
    required this.messages,
    required this.data,
  });

  String status;
  List<String> messages;
  Data data;

  factory SurveyFormDownloadModel.fromJson(Map<String, dynamic> json) => SurveyFormDownloadModel(
    status: json["status"],
    messages: List<String>.from(json["messages"].map((x) => x)),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": List<dynamic>.from(messages.map((x) => x)),
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.surveyTable,
    required this.surveyLines,
  });

  SurveyTable surveyTable;
  List<SurveyLine> surveyLines;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    surveyTable: SurveyTable.fromJson(json["surveyTable"]),
    surveyLines: List<SurveyLine>.from(json["surveyLines"].map((x) => SurveyLine.fromJson(x))),
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
    required this.dataMoris,
    required this.formType,
    required this.municipiu,
    required this.subDistritu,
    required this.suku,
    required this.aldeia,
    required this.naranIntervistador,
    required this.transTime,
    required this.deviceId,
  });

  String transId;
  String title;
  String description;
  String transDate;
  String dataMoris;
  String formType;
  int municipiu;
  int subDistritu;
  int suku;
  int aldeia;
  String naranIntervistador;
  String transTime;
  String deviceId;

  factory SurveyTable.fromJson(Map<String, dynamic> json) => SurveyTable(
    transId: json["trans_Id"],
    title: json["title"],
    description: json["description"],
    transDate: json["trans_Date"],
    dataMoris: json["data_Moris"],
    formType: json["form_Type"],
    municipiu: json["municipiu"],
    subDistritu: json["sub_Distritu"],
    suku: json["suku"],
    aldeia: json["aldeia"],
    naranIntervistador: json["naran_Intervistador"],
    transTime: json["trans_Time"],
    deviceId: json["device_Id"],
  );

  Map<String, dynamic> toJson() => {
    "trans_Id": transId,
    "title": title,
    "description": description,
    "trans_Date": transDate,
    "data_Moris": dataMoris,
    "form_Type": formType,
    "municipiu": municipiu,
    "sub_Distritu": subDistritu,
    "suku": suku,
    "aldeia": aldeia,
    "naran_Intervistador": naranIntervistador,
    "trans_Time": transTime,
    "device_Id": deviceId,
  };
}
