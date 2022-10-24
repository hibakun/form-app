import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/formtabelModel.dart';
import 'package:form_app/model/surveyFormDownloadModel.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/dashboard/item/read_form.dart';
import 'package:form_app/ui/widget/waringdialog.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<FormModel> _datalistform = [];
  FormTableData? _dataTable;
  var _data = [];
  var form;

  Future addDb() async {
    showWarningDialog("process",
        customMessage: "Carregando os dados.\nPode demorar alguns segundos");
    try {
      FormtableModel result = await ApiService().formtableAPI();
      _data = result.data;
    } catch (error) {
      print('no internet');
    }
    for (int i = 0; i < _data.length; i++) {
      _dataTable = _data[i];
      form = FormModel(
          id: _dataTable!.id,
          code: _dataTable!.code,
          title: _dataTable!.title,
          description: _dataTable!.description,
          formType: _dataTable!.formType);
      await downloadForm(_dataTable!.formType);
      await FormTableDatabase.instance.createForm(form);
    }
    Navigator.pop(context);
    read();
  }

  Future read() async {
    _datalistform = await FormTableDatabase.instance.readAll();
    setState(() {});
  }

  Future downloadForm(String type) async {
    List result = [];
    List<SurveyLine> question = [];

    try {
      SurveyFormDownloadModel model =
          await ApiService().surveyformdownload(type: type);

      result.add(model.data.surveyTable.formType);
      result.add('title');
      result.add(model.data.surveyTable.title);
      result.add('description');
      result.add(model.data.surveyTable.description);
      result.add('name');
      result.add(model.data.surveyTable.name);
      result.add('birthDate');
      result.add(model.data.surveyTable.birthDate);
      result.add('municipality');
      result.add(model.data.surveyTable.municipality);
      result.add('subDistrict');
      result.add(model.data.surveyTable.subDistrict);
      result.add('village');
      result.add(model.data.surveyTable.village);
      result.add('subVillage');
      result.add(model.data.surveyTable.subVillage);
      result.add('interviewerName');
      result.add(model.data.surveyTable.interviewerName);
      result.add('headVillageName');
      result.add(model.data.surveyTable.headVillageName);

      question = model.data.surveyLines;
      print("Question LENGTH" + question.length.toString());
      for (int i = 0; i < question.length; i++) {
        await FormTableDatabase.instance.createQuestion(
            QuestionFields.questionTable,
            QuestionDbModel(
              formType: result[0],
              kode_soal: question[i].dtoFormLine.id,
              question: question[i].dtoFormLine.question,
              dropdown: question[i].dtoFormLine.dropDown,
              input_type: question[i].dtoFormLine.inputType,
            ));
      }

      //title
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[1],
            value: result[2],
          ));

      //description
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[3],
            value: result[4],
          ));

      //name
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[5],
            value: result[6],
          ));

      //birthDate
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[7],
            value: result[8].toString(),
          ));

      //municipality
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[9],
            value: result[10].toString(),
          ));

      //subDistrict
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[11],
            value: result[12].toString(),
          ));

      //village
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[13],
            value: result[14].toString(),
          ));

      //subVillage
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[15],
            value: result[16].toString(),
          ));

      //interviewerName
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[17],
            value: result[18].toString(),
          ));

      //headVillageName
      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[19],
            value: result[20].toString(),
          ));

      print("STATUS API: " + model.status);
    } catch (error) {
      print('no internet');
    }
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
        title: Text("Página inicial (Formulário de download)"),
      ),
      body: _buildListForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_datalistform.isEmpty) {
            addDb();
          } else {
            _datalistform.clear();
            read();
          }
        },
        child: Icon(Icons.download),
      ),
    );
  }

  _buildListForm() {
    return _datalistform.length == 0
        ? Center(child: Text("no data available"))
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemCount: _datalistform.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ReadFormPage(
                                formType: _datalistform[index].formType,
                              ))));
                },
                child: Card(
                  color: Colors.white70,
                  elevation: 4,
                  shadowColor: Colors.black,
                  child: Center(child: Text(_datalistform[index].code)),
                ),
              );
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
