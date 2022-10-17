import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.logout,
                    size: 28.h,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                SvgPicture.asset(
                  'assets/profile.svg',
                  width: 125.w,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Admin',
                  style: theme.headline1,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'admin@gmail.com',
                  style: theme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
