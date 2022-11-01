import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/database/formtabelModel.dart';
import 'package:form_app/model/surveyFormDownloadModel.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/dashboard/item/fill_form.dart';
import 'package:form_app/ui/dashboard/item/read_form.dart';
import 'package:form_app/ui/widget/waringdialog.dart';

class ListFormPage extends StatefulWidget {
  ListFormPage({Key? key}) : super(key: key);

  @override
  State<ListFormPage> createState() => _ListFormPageState();
}

class _ListFormPageState extends State<ListFormPage> {
  List<FormModel> _datalistform = [];
  bool _isLoad = false;
  var form;

  Future read() async {
    setState(() {
      _isLoad = true;
    });
    _datalistform = await FormTableDatabase.instance.readAll();
    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50.h,
          title: Text("Selecione o formulário", style: TextStyle(fontSize: 20)),
        ),
        body: _buildListForm(),
      ),
    );
  }

  _buildListForm() {
    return _isLoad
        ? Center(child: CircularProgressIndicator())
        : _datalistform.length == 0
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/no_data.svg", width: 100.w),
                    SizedBox(height: 30.h),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("Laiha Formulário\nDisponível",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25)),
                    ),
                  ],
                ),
              )
            : Container(
                height: double.infinity,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: _datalistform.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => FillFormPage(
                                      formType: _datalistform[index].formType,
                                    ))));
                      },
                      child: Card(
                        color: Colors.white54,
                        elevation: 4,
                        shadowColor: Colors.black,
                        child: Center(
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(_datalistform[index].code,
                                    style: TextStyle(fontSize: 20)))),
                      ),
                    );
                  },
                ),
              );
  }

  void showWarningDialog(String type, {required String customMessage}) {
    String dialogType = "";
    String title = "";
    String message = "";
    IconData icon = Icons.warning;

    switch (type) {
      case "warning":
        dialogType = "warning";
        title = "Review";
        message = customMessage;
        icon = Icons.warning;
        break;
      case "process":
        dialogType = "process";
        title = "Process";
        message = customMessage;
        icon = Icons.hourglass_bottom;
        break;
      case "succeed":
        dialogType = "succeed";
        title = "Succeed";
        message = "Successfully";
        icon = Icons.check_circle_outline;
        break;
      case "error":
        dialogType = "error";
        message = customMessage;
        title = "Error";
        icon = Icons.error;
        break;
      default:
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => new Dialog(
                child: WarningDialog(
              type: dialogType,
              title: title,
              message: message,
              icon: icon,
            )));
  }
}
