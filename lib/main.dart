import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/theme_data.dart';
import 'package:form_app/ui/login/login.dart';
import 'package:form_app/ui/splashscreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, child) {
        return MaterialApp(
          title: 'Form App',
          theme: AppThemeData.getTheme(),
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: Splash(),
    );
  }
}
