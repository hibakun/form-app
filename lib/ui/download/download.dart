import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/formtabelModel.dart';
import 'package:form_app/service/api_service.dart';

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
      print('Hasil dari api ke: ' +
          i.toString() +
          ' Id: ' +
          _dataTable!.id.toString() +
          ' Code: ' +
          _dataTable!.code +
          ' Title: ' +
          _dataTable!.title +
          ' Desc: ' +
          _dataTable!.description +
          ' Type: ' +
          _dataTable!.formType);
      await FormTableDatabase.instance.create(form);
    }
    read();
  }

  Future read() async {
    _datalistform = await FormTableDatabase.instance.readAll();
    setState(() {
      _isLoad = false;
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
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
                      return Card(
                        color: Colors.purple[300],
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(_datalistform[index].code,
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }),
              );
  }
}
