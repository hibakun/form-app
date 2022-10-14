import 'dart:convert';
import 'dart:io';

import 'package:form_app/model/loginModel.dart';
import 'package:form_app/model/municipalityLikeModel.dart';
import 'package:form_app/model/municipalityModel.dart';
import 'package:form_app/model/subdisctrictByMuniModel.dart';
import 'package:form_app/model/subdisctrictLikeModel.dart';
import 'package:form_app/model/subdisctrictModel.dart';
import 'package:form_app/model/subvillageModel.dart';
import 'package:form_app/model/villageBySubModel.dart';
import 'package:form_app/model/villageLikeModel.dart';
import 'package:form_app/model/villageModel.dart';
import 'package:form_app/service/server_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<LoginModel> loginAPI(
      {required String username, required String password}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"username": username, "password": password};
    print("RAW LOGIN: " + body.toString());
    print("URL LOGIN: " + ServerConfig.baseUrl + ServerConfig.loginUrl);
    final res = await http.post(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.loginUrl),
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
    Map<String, String> headers = {
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    print("URL MUNICIPALITY: " +
        ServerConfig.baseUrl +
        ServerConfig.municipality);
    final res = await http.get(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.municipality),
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    final body = {"keyword": "Man"};
    print("RAW MUNICIPALITY LIKE: " + body.toString());
    print("URL MUNICIPALITY LIKE: " +
        ServerConfig.baseUrl +
        ServerConfig.municipalityLike);
    final res = await http.post(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.municipalityLike),
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
    Map<String, String> headers = {
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    print("URL SUBDISCTRICT: " +
        ServerConfig.baseUrl +
        ServerConfig.subdisctrict);
    final res = await http.get(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.subdisctrict),
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    final body = {"keyword": ""};
    print("RAW SUBDISCTRICT LIKE: " + body.toString());
    print("URL SUBDISCTRICT LIKE: " +
        ServerConfig.baseUrl +
        ServerConfig.subdisctrictLike);
    final res = await http.post(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.subdisctrictLike),
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

  Future<SubdisctrictByMuniModel> subdisctrictByMuniAPI() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    final body = {
      "id": "2",
      "code": "MN002",
      "name": "Ainaro",
      "description": "Município Ainaro"
    };
    print("RAW SUBDISCTRICT BYMUNI: " + body.toString());
    print("URL SUBDISCTRICT BYMUNI: " +
        ServerConfig.baseUrl +
        ServerConfig.subdisctrictByMuni);
    final res = await http.post(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.subdisctrictByMuni),
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
    Map<String, String> headers = {
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    print("URL VILLAGE: " + ServerConfig.baseUrl + ServerConfig.village);
    final res = await http.get(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.village),
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
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    final body = {"keyword": ""};
    print("RAW VILLAGE LIKE: " + body.toString());
    print(
        "URL VILLAGE LIKE: " + ServerConfig.baseUrl + ServerConfig.villageLike);
    final res = await http.post(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.villageLike),
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

  Future<VillageBySubModel> villageBySubAPI() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    final body = {
      "id": 1,
      "code": "PA001",
      "name": "Aileu",
      "description": "Posto Aileu Vila "
    };
    print("RAW VILLAGE BYSUB: " + body.toString());
    print("URL VILLAGE BYSUB: " +
        ServerConfig.baseUrl +
        ServerConfig.villageBySub);
    final res = await http.post(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.villageBySub),
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
    Map<String, String> headers = {
      'Authorization': "Bearer " + prefs.getString('token').toString(),
    };
    print("URL SUBVILLAGE: " + ServerConfig.baseUrl + ServerConfig.subvillage);
    final res = await http.get(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.subvillage),
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
}
