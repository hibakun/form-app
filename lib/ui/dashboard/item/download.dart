import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/municipality.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/database/formtabelModel.dart';
import 'package:form_app/model/database/subdistrict.dart';
import 'package:form_app/model/database/subvillage.dart';
import 'package:form_app/model/database/village.dart';
import 'package:form_app/model/municipality_model.dart';
import 'package:form_app/model/subvillage_model.dart';
import 'package:form_app/model/surveyFormDownloadModel.dart';
import 'package:form_app/model/village_model.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/dashboard/item/read_form.dart';
import 'package:form_app/ui/widget/waringdialog.dart';

import '../../../model/subdisctrict_model.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<FormModel> _datalistform = [];
  FormTableData? _dataTable;
  MunicipalityData? _municipalityTable;
  SubdisctrictData? _subdisctrictTable;
  VillageData? _villageTable;
  SubvillageData? _subvillageTable;

  var _data = [];
  var _municipalityData = [];
  var _subdistrictData = [];
  var _villageData = [];
  var _subvillageData = [];
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

    try {
      MunicipalityModel result = await ApiService().municipalityAPI();
      _municipalityData = result.data;
    } catch (error) {
      print('no internet');
    }

    try {
      SubdisctrictModel result = await ApiService().subdisctrictAPI();
      _subdistrictData = result.data;
    } catch (error) {
      print('no internet');
    }

    try {
      VillageModel result = await ApiService().villageAPI();
      _villageData = result.data;
    } catch (error) {
      print('no internet');
    }

    try {
      SubvillageModel result = await ApiService().subvillageAPI();
      _subvillageData = result.data;
    } catch (error) {
      print('no internet');
    }


    for(int i = 0; i < _municipalityData.length; i++){
      _municipalityTable = _municipalityData[i];
      await FormTableDatabase.instance.createMunicipality(MunicipalityFields.tableMunicipality,
          MunicipalityDatabaseModel(
            id_dropdown: _municipalityTable?.id,
            name: _municipalityTable?.name,
            kode_municipality: _municipalityTable?.code
          ));
    }

    for(int i = 0; i < _subdistrictData.length; i++){
      _subdisctrictTable = _subdistrictData[i];
      await FormTableDatabase.instance.createSubdistrict(SubdistrictFields.tableSubdistrict,
          SubdistrictDatabaseModel(
            id_dropdown: _subdisctrictTable?.id,
            name: _subdisctrictTable?.name,
            kode_subdistrict: _subdisctrictTable?.code,
            kode_municipality: _subdisctrictTable?.municipality?.code
          ));
    }

    for(int i = 0; i < _villageData.length; i++){
    _villageTable = _villageData[i];
      await FormTableDatabase.instance.createVillage(VillageFields.tableVillage,
          VillageDatabaseModel(
            id_dropdown: _villageTable?.id,
            name: _villageTable?.name,
            kode_village: _villageTable?.code,
            kode_subdistrict: _villageTable?.subDistrict?.code,
          ));
    }

    for(int i = 0; i < _subvillageData.length; i++){
      _subvillageTable = _subvillageData[i];
      await FormTableDatabase.instance.createSubvillage(SubvillageFields.tableSubvillage,
          SubVillageDatabaseModel(
            id_dropdown: _subvillageTable?.id,
            name: _subvillageTable?.name,
            kode_subvillage: _subvillageTable?.code,
            kode_village: _subvillageTable?.village?.code
          ));
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
      result.add('villageHeadName');
      result.add(model.data.surveyTable.villageHeadName);
      print("FORM TYPE" + result[0].toString());

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
        toolbarHeight: 50.h,
        title: Text("Página inicial (Formulário de download)",
            style: TextStyle(fontSize: 20)),
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
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/no_data.svg", width: 100.w),
                SizedBox(height: 30.h),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("Nenhum formulário\ndisponível",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
          )
        : GridView.builder(
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
                          builder: ((context) => ReadFormPage(
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
