import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/ui/download/download.dart';
import 'package:form_app/ui/fill_form/fill_form.dart';
import 'package:form_app/ui/upload_data/upload_data.dart';
import 'package:form_app/ui/user/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final _tabs = [
    DownloadPage(),
    FillFormPage(),
    UploadDataPage(),
    UserPage(),
  ];

  final _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.download),
      label: "Download",
      tooltip: "Download",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_chart),
      label: "Forma",
      tooltip: "Forma",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.upload),
      label: "Envio",
      tooltip: "Envio",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Usuário",
      tooltip: "Usuário",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: _items,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedFontSize: 16.sp,
          unselectedFontSize: 16.sp,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
