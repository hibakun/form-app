import 'dart:convert';
import 'dart:io';

import 'package:form_app/model/database/formtabelModel.dart';
import 'package:form_app/model/login_model.dart';
import 'package:form_app/model/municipality_like_model.dart';
import 'package:form_app/model/municipality_model.dart';
import 'package:form_app/model/subdisctrict_by_muni_model.dart';
import 'package:form_app/model/subdisctrict_like_model.dart';
import 'package:form_app/model/subdisctrict_model.dart';
import 'package:form_app/model/subvillage_by_vill_model.dart';
import 'package:form_app/model/subvillage_find_like.dart';
import 'package:form_app/model/subvillage_model.dart';
import 'package:form_app/model/surveyFormDownloadModel.dart';
import 'package:form_app/model/upload_model.dart';
import 'package:form_app/model/village_by_sub_model.dart';
import 'package:form_app/model/village_like_model.dart';
import 'package:form_app/model/village_model.dart';
import 'package:form_app/service/server_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ApiService {
  Future<LoginModel> loginAPI(
      {required String username, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"username": username, "password": password};
    print("RAW LOGIN: " + body.toString());
    print("URL LOGIN: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.loginUrl);
    final res = await http.post(
        Uri.parse(
            prefs.getString('baseURL').toString() + ServerConfig.loginUrl),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(LOGIN): " + res.statusCode.toString());
    print("RES LOGIN: " + res.body.toString());
    if (res.statusCode == 200) {
      return LoginModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<MunicipalityModel> municipalityAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Authorization': "Bearer " + result.accessToken,
    };
    print("HEADER MUNICIPALITY: " + headers.toString());
    print("URL MUNICIPALITY: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.municipality);
    final res = await http.get(
        Uri.parse(
            prefs.getString('baseURL').toString() + ServerConfig.municipality),
        headers: headers);
    print("STATUS CODE(MUNICIPALITY): " + res.statusCode.toString());
    print("RES MUNICIPALITY: " + res.body.toString());
    if (res.statusCode == 200) {
      return MunicipalityModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<MunicipalityLikeModel> municipalityLikeAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"keyword": "Man"};
    print("HEADER MUNICIPALITY LIKE: " + headers.toString());
    print("RAW MUNICIPALITY LIKE: " + body.toString());
    print("URL MUNICIPALITY LIKE: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.municipalityLike);
    final res = await http.post(
        Uri.parse(prefs.getString('baseURL').toString() +
            ServerConfig.municipalityLike),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(MUNICIPALITY LIKE): " + res.statusCode.toString());
    print("RES MUNICIPALITY LIKE: " + res.body.toString());
    if (res.statusCode == 200) {
      return MunicipalityLikeModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<SubdisctrictModel> subdisctrictAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Authorization': "Bearer " + result.accessToken,
    };
    print("HEADER SUBDISCTRICT: " + headers.toString());
    print("URL SUBDISCTRICT: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.subdisctrict);
    final res = await http.get(
        Uri.parse(
            prefs.getString('baseURL').toString() + ServerConfig.subdisctrict),
        headers: headers);
    print("STATUS CODE(SUBDISCTRICT): " + res.statusCode.toString());
    print("RES SUBDISCTRICT: " + res.body.toString());
    if (res.statusCode == 200) {
      return SubdisctrictModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<SubdisctrictLikeModel> subdisctrictLikeAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"keyword": ""};
    print("HEADER SUBDISCTRICT LIKE: " + headers.toString());
    print("RAW SUBDISCTRICT LIKE: " + body.toString());
    print("URL SUBDISCTRICT LIKE: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.subdisctrictLike);
    final res = await http.post(
        Uri.parse(prefs.getString('baseURL').toString() +
            ServerConfig.subdisctrictLike),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(SUBDISCTRICT LIKE): " + res.statusCode.toString());
    print("RES SUBDISCTRICT LIKE: " + res.body.toString());
    if (res.statusCode == 200) {
      return SubdisctrictLikeModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<SubdisctrictByMuniModel> subdisctrictByMuniAPI(
      {required String id,
      required String code,
      required String name,
      required String desc}) async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"id": id, "code": code, "name": name, "description": desc};
    print("HEADER SUBDISCTRICT BYMUNI: " + headers.toString());
    print("RAW SUBDISCTRICT BYMUNI: " + body.toString());
    print("URL SUBDISCTRICT BYMUNI: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.subdisctrictByMuni);
    final res = await http.post(
        Uri.parse(prefs.getString('baseURL').toString() +
            ServerConfig.subdisctrictByMuni),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(SUBDISCTRICT BYMUNI): " + res.statusCode.toString());
    print("RES SUBDISCTRICT BYMUNI: " + res.body.toString());
    if (res.statusCode == 200) {
      return SubdisctrictByMuniModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<VillageModel> villageAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Authorization': "Bearer " + result.accessToken,
    };
    print("HEADER VILLAGE: " + headers.toString());
    print("URL VILLAGE: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.village);
    final res = await http.get(
        Uri.parse(prefs.getString('baseURL').toString() + ServerConfig.village),
        headers: headers);
    print("STATUS CODE(VILLAGE): " + res.statusCode.toString());
    print("RES VILLAGE: " + res.body.toString());
    if (res.statusCode == 200) {
      return VillageModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<VillageLikeModel> villageLikeAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"keyword": ""};
    print("HEADER VILLAGE LIKE: " + headers.toString());
    print("RAW VILLAGE LIKE: " + body.toString());
    print("URL VILLAGE LIKE: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.villageLike);
    final res = await http.post(
        Uri.parse(
            prefs.getString('baseURL').toString() + ServerConfig.villageLike),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(VILLAGE LIKE): " + res.statusCode.toString());
    print("RES VILLAGE LIKE: " + res.body.toString());
    if (res.statusCode == 200) {
      return VillageLikeModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<VillageBySubModel> villageBySubAPI(
      {required int id,
      required String code,
      required String name,
      required String desc}) async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"id": id, "code": code, "name": name, "description": desc};
    print("HEADER VILLAGE BYSUB: " + headers.toString());
    print("RAW VILLAGE BYSUB: " + body.toString());
    print("URL VILLAGE BYSUB: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.villageBySub);
    final res = await http.post(
        Uri.parse(
            prefs.getString('baseURL').toString() + ServerConfig.villageBySub),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(VILLAGE BYSUB): " + res.statusCode.toString());
    print("RES VILLAGE BYSUB: " + res.body.toString());
    if (res.statusCode == 200) {
      return VillageBySubModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<SubvillageModel> subvillageAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Authorization': "Bearer " + result.accessToken,
    };
    print("HEADER SUBVILLAGE: " + headers.toString());
    print("URL SUBVILLAGE: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.subvillage);
    final res = await http.get(
        Uri.parse(
            prefs.getString('baseURL').toString() + ServerConfig.subvillage),
        headers: headers);
    print("STATUS CODE(SUBVILLAGE): " + res.statusCode.toString());
    print("RES SUBVILLAGE: " + res.body.toString());
    if (res.statusCode == 200) {
      return SubvillageModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<SubVillageLikeModel> subVillageLikeAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"keyword": ""};
    print("HEADER SUB VILLAGE LIKE: " + headers.toString());
    print("RAW SUB VILLAGE LIKE: " + body.toString());
    print("URL SUB VILLAGE LIKE: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.subvillageLike);
    final res = await http.post(
        Uri.parse(prefs.getString('baseURL').toString() +
            ServerConfig.subvillageLike),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(SUB VILLAGE LIKE): " + res.statusCode.toString());
    print("RES SUB VILLAGE LIKE: " + res.body.toString());
    if (res.statusCode == 200) {
      return SubVillageLikeModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<SubvillageByVillModel> subVillageByVillAPI(
      {required int id,
      required String code,
      required String name,
      required String desc}) async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"id": id, "code": code, "name": name, "description": desc};
    print("HEADER SUBVILLAGE BYVILL: " + headers.toString());
    print("RAW SUBVILLAGE BYVILL: " + body.toString());
    print("URL SUBVILLAGE BYVILL: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.subvillageByVill);
    final res = await http.post(
        Uri.parse(prefs.getString('baseURL').toString() +
            ServerConfig.subvillageByVill),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(SUBVILLAGE BYVILL): " + res.statusCode.toString());
    print("RES SUBVILLAGE BYVILL: " + res.body.toString());
    if (res.statusCode == 200) {
      return SubvillageByVillModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<FormtableModel> formtableAPI() async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Authorization': "Bearer " + result.accessToken,
    };
    print("HEADER FORMTABLE: " + headers.toString());
    print("URL FORMTABLE: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.formtable);
    final res = await http.get(
        Uri.parse(
            prefs.getString('baseURL').toString() + ServerConfig.formtable),
        headers: headers);
    print("STATUS CODE(FORMTABLE): " + res.statusCode.toString());
    print("RES FORMTABLE: " + res.body.toString());
    if (res.statusCode == 200) {
      return FormtableModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<SurveyFormDownloadModel> surveyformdownload(
      {required String type}) async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = {"keyword": type};
    print("HEADER SURVEY FORM DOWNLOAD: " + headers.toString());
    print("RAW SURVEY FORM DOWNLOAD: " + body.toString());
    print("URL SURVEY FORM DOWNLOAD: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.surveyformdownload);
    final res = await http.post(
        Uri.parse(prefs.getString('baseURL').toString() +
            ServerConfig.surveyformdownload),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(SURVEY FORM DOWNLOAD): " + res.statusCode.toString());
    print("RES SURVEY FORM DOWNLOAD: " + res.body.toString());
    if (res.statusCode == 200) {
      return SurveyFormDownloadModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<UploadModel> surveyformupload({required dynamic jsonRaw}) async {
    final prefs = await SharedPreferences.getInstance();
    LoginModel result = await loginAPI(
        username: prefs.getString('user').toString(),
        password: prefs.getString('pass').toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + result.accessToken,
    };
    final body = jsonRaw;
    print("HEADER SURVEY FORM UPLOAD: " + headers.toString());
    log("RAW SURVEY FORM UPLOAD: " + body.toString());
    print("URL SURVEY FORM UPLOAD: " +
        prefs.getString('baseURL').toString() +
        ServerConfig.surveyformupload);
    final res = await http.post(
        Uri.parse(prefs.getString('baseURL').toString() +
            ServerConfig.surveyformupload),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(SURVEY FORM UPLOAD): " + res.statusCode.toString());
    print("RES SURVEY FORM UPLOAD: " + res.body.toString());
    if (res.statusCode == 200) {
      return UploadModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }
}
