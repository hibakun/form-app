import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_app/ui/dashboard/dashboard.dart';
import 'package:form_app/ui/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String _deviceData = "";

  @override
  void initState() {
    initPlatformState();
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user') == null && prefs.getString('pass') == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Dashboard()));
      }
    });
    super.initState();
  }

  Future<void> initPlatformState() async {
    var deviceData = "";

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
    } on PlatformException {
      deviceData = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceId', _deviceData);
    print("DEVICE ID: " + prefs.getString("deviceId").toString());
  }

  String _readAndroidBuildData(AndroidDeviceInfo build) {
    return build.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/splash.svg',
              width: 200.w,
            ),
          ),
          SizedBox(height: 50.h),
          Center(
              child: Text("Formulário de Pesquisa",
                  style: TextStyle(
                      color: Colors.red[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 30)))
        ],
      ),
    );
  }
}
