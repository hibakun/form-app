import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_app/model/upload_model.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/widget/waringdialog.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/FormDb.dart';
import '../../../model/database/content.dart';
import '../../../model/database/question_answer.dart';

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({Key? key}) : super(key: key);

  @override
  State<UploadDataPage> createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  List<QuestionAnswerDbModel> questionList = [];
  List<ContentDatabaseModel> contentList = [];
  List<ContentDatabaseModel> contentStatus = [];
  List<ContentDatabaseModel> readContent = [];
  List<QuestionAnswerDbModel> readQuestion = [];
  bool isLoading = false;

  Future read() async {
    setState(() {
      isLoading = true;
    });
    contentList = await FormTableDatabase.instance.contentReadAll();
    questionList = await FormTableDatabase.instance.readQuestionAnswerAll();
    contentList.forEach((element) {
      print("STATUS: " + element.status.toString());
    });
    for (int i = 0; i < contentList.length; i++) {
      if (contentList[i].status != 0) continue;
      contentStatus.add(contentList[i]);
    }
    setState(() {
      isLoading = false;
    });
  }

  upload() async {
    setState(() {
      isLoading = true;
    });
    showWarningDialog("process",
        customMessage: "Carregando os dados.\nPode demorar alguns segundos");
    String tdata = DateFormat("hh:mm:ss").format(DateTime.now());
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var header = Map<String, dynamic>();
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString('deviceId');
    var surveyTable = Map<String, dynamic>();
    List status = [];
    List listQuestion = [];
    for (int i = 0; i < contentList.length; i++) {
      if (contentList[i].status != 0) continue;
      status.add(contentList[i].code);
    }
    for (int i = 0; i < status.length; i++) {
      readContent = await FormTableDatabase.instance.readContent(status[i]);
      for (int p = 0; p < readContent.length; p++) {
        if (readContent[p].dropdownId != null) continue;
        header[readContent[p].key.toString()] = readContent[p].value.toString();
        print(header);
      }
      for (int p = 0; p < readContent.length; p++) {
        if (readContent[p].dropdownId == null) continue;
        header[readContent[p].key.toString()] = readContent[p].dropdownId;
        print(header);
      }
      readQuestion =
          await FormTableDatabase.instance.readQuestionAnswer(status[i]);
      readQuestion.forEach((element) {
        var question = Map<String, dynamic>();
        question["id"] = element.id_soal;
        question["inputType"] = element.input_type;
        question["question"] = element.question;
        question["dropDown"] = element.dropdown;
        var dtoForm = Map<String, dynamic>();
        dtoForm["dtoFormLine"] = question;
        dtoForm["userInput"] = element.answer.toString();
        dtoForm["transTime"] = tdata;
        listQuestion.add(dtoForm);
      });
      header["transId"] = status[i].toString();
      header["transTime"] = tdata;
      header["transDate"] = cdate;
      header["deviceId"] = deviceId.toString();
      surveyTable["surveyTable"] = header;
      surveyTable["surveyLines"] = listQuestion;
      await Clipboard.setData(
          ClipboardData(text: '${jsonEncode(surveyTable)}'));
      //post disini
      UploadModel _model =
          await ApiService().surveyformupload(jsonRaw: surveyTable);
      FormTableDatabase.instance.updateContentStatus(1, status[i]);
    }
    Navigator.pop(context);
    showWarningDialog("succeed", customMessage: "Dados de upload concluídos");
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
    contentStatus.clear();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Página inicial (Enviar formulário)"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : contentStatus.isEmpty
              ? Center(
                  child: Text("Nenhum formulário adicionado ainda"),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: Text(contentStatus[index].code.toString()),
                        subtitle:
                            Text(contentStatus[index].formType.toString()),
                      ),
                    );
                  },
                  itemCount: contentStatus.length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAlertDialogUpload(context);
        },
        child: Icon(Icons.upload),
      ),
    );
  }

  showAlertDialogUpload(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Não"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Sim"),
      onPressed: () {
        upload();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text("você quer carregar?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
        message = customMessage;
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
