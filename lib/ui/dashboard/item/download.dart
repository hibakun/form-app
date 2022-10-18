import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
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

    try {
      SurveyFormDownloadModel model =
          await ApiService().surveyformdownload(type: type);

      result.add(model.data.surveyTable.formType);
      result.add('title');
      result.add(model.data.surveyTable.title);
      result.add('name');
      result.add(model.data.surveyTable.name);
      result.add('birthDate');
      result.add(model.data.surveyTable.birthDate);
      result.add('subDistrict');
      result.add(model.data.surveyTable.subDistrict);
      result.add('subVillage');
      result.add(model.data.surveyTable.subVillage);

      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[1],
            value: result[2],
          ));

      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[3],
            value: result[4],
          ));

      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[5],
            value: result[6],
          ));

      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[7],
            value: result[8],
          ));

      await FormTableDatabase.instance.create(
          HeaderFields.header,
          HeaderDatabaseModel(
            formType: result[0],
            key: result[9],
            value: result[10],
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
                          Navigator.push(context, MaterialPageRoute(builder: ((context) => FillFormPage(formType: _datalistform[index].formType,))));
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
