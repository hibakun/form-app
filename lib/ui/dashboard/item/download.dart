import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/formtabelModel.dart';
import 'package:form_app/model/surveyFormDownloadModel.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/dashboard/item/fill_form.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<FormModel> _datalistform = [];
  FormTableData? _dataTable;
  var _data = [];
  var form;
  bool _isLoad = false;

  Future addDb() async {
    setState(() {
      _isLoad = true;
    });
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

    read();
  }

  Future read() async {
    _datalistform = await FormTableDatabase.instance.readAll();
    setState(() {
      _isLoad = false;
    });
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildDownloadButton(),
            Padding(padding: EdgeInsets.only(top: 12), child: _buildListForm()),
          ],
        ),
      ),
    );
  }

  _buildDownloadButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          height: 40.h,
          width: 200.w,
          child: ElevatedButton(
            child: Text('Download Form'),
            onPressed: () async {
              if (_datalistform.isEmpty) {
                addDb();
              } else {
                _datalistform.clear();
                read();
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
          ),
        ),
      ),
    );
  }

  _buildListForm() {
    return _isLoad
        ? Center(child: CircularProgressIndicator())
        : _datalistform.length == 0
            ? Center(child: Text("no data available"))
            : Container(
                height: 625.h,
                child: ListView.builder(
                    itemCount: _datalistform.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          //
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => FillFormPage(
                                        formType: _datalistform[index].formType,
                                      ))));
                        },
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(_datalistform[index].code),
                          ),
                        ),
                      );
                    }),
              );
  }
}
