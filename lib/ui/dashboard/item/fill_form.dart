import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/shared_code.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/municipality_model.dart';
import 'package:form_app/model/subdisctrict_by_muni_model.dart';
import 'package:form_app/model/subdisctrict_model.dart';
import 'package:form_app/model/subvillage_model.dart';
import 'package:form_app/model/village_by_sub_model.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/widget/custom_text_field.dart';
import 'package:intl/intl.dart';

class FillFormPage extends StatefulWidget {
  final String formType;

  const FillFormPage({Key? key, required this.formType}) : super(key: key);

  @override
  State<FillFormPage> createState() => _FillFormPageState();
}

class _FillFormPageState extends State<FillFormPage> {
  MunicipalityData? dropdownMunicipality = null;
  SubdisctrictByMuniData? dropdownsubDistrict = null;
  VillageBySubData? dropdownVillage = null;
  SubvillageData? dropdownsubVillage = null;
  List<MunicipalityData> municipalityList = [];
  List<SubdisctrictByMuniData> subDistrictList = [];
  List<VillageBySubData> villageList = [];
  List<SubvillageData> subVillageList = [];

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _selectedDate = DateTime.now();
  String _selectDate = "";
  final _nameController = TextEditingController();
  final _interviewerController = TextEditingController();
  final _headVillageController = TextEditingController();
  bool _isload = false;
  bool _isloading = false;
  bool _showsubDistrict = false;
  bool _showvillage = false;
  bool _showsubVillage = false;
  List<HeaderDatabaseModel> headers = [];
  List<QuestionDbModel> questions = [];

  read() async {
    setState(() {
      _isloading = true;
    });
    headers = await FormTableDatabase.instance.readHeader(widget.formType);
    for (int i = 0; i < headers.length; i++) {
      print("form type : " + headers[i].formType.toString());
      print("form key : " + headers[i].key.toString());
      print("form value : " + headers[i].value.toString());
    }
    questions = await FormTableDatabase.instance.readQuestion(widget.formType);
    for (int i = 0; i < questions.length; i++) {
      print("form question : " + questions[i].question.toString());
    }
    MunicipalityModel _resMunicipality = await ApiService().municipalityAPI();
    setState(() {
      municipalityList = _resMunicipality.data;
      _isloading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectDate = _dateFormat.format(_selectedDate);
    read();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _isloading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Center(
                                child: Text(headers[0].value.toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                          ),
                          SizedBox(height: 30.h),
                          Center(
                              child: Text(headers[1].value.toString(),
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center)),
                          SizedBox(height: 30.h),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(headers[2].key.toString() + " :",
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: CustomTextField(
                              controller: _nameController,
                              inputType: TextInputType.text,
                              validator: (value) =>
                                  SharedCode().emptyValidator(value),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(headers[3].key.toString() + " :",
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: _buildDatePickerField(),
                          ),
                          SizedBox(height: 20.h),
                          _buildDropdownMunicipality(),
                          Padding(
                            padding: EdgeInsets.only(left: 12, top: 10),
                            child: Text(headers[8].key.toString() + " :",
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: CustomTextField(
                              controller: _interviewerController,
                              inputType: TextInputType.text,
                              validator: (value) =>
                                  SharedCode().emptyValidator(value),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12, top: 10),
                            child: Text(headers[9].key.toString() + " :",
                                style: TextStyle(fontSize: 15)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: CustomTextField(
                              controller: _headVillageController,
                              inputType: TextInputType.text,
                              validator: (value) =>
                                  SharedCode().emptyValidator(value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isload
                        ? Container(
                            color: Colors.white.withOpacity(0.5),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                )),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () {
        _showDatePicker(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
        height: 60.h,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_selectDate.toString(), style: TextStyle(fontSize: 14)),
              SizedBox(
                width: 10.w,
              ),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    setState(() {
      if (selected != null && selected != _selectedDate) {
        _selectedDate = selected;
        _selectDate = _dateFormat.format(selected);
      }
    });
  }

  _buildDropdownMunicipality() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(headers[4].key.toString() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<MunicipalityData>(
                  isExpanded: true,
                  value: dropdownMunicipality,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (MunicipalityData? newValue) async {
                    if (dropdownMunicipality != null) {
                      setState(() {
                        _isload = true;
                      });
                      SubdisctrictByMuniModel _resSubdistrict =
                          await ApiService().subdisctrictByMuniAPI(
                              id: newValue!.id.toString(),
                              code: newValue.code,
                              name: newValue.name,
                              desc: newValue.description);
                      setState(() {
                        dropdownsubDistrict = null;
                        dropdownVillage = null;
                        dropdownsubVillage = null;
                        dropdownMunicipality = newValue;
                        _showsubDistrict = true;
                        _showvillage = false;
                        _showsubVillage = false;
                        subDistrictList = _resSubdistrict.data;
                        _isload = false;
                      });
                    } else {
                      setState(() {
                        _isload = true;
                      });
                      SubdisctrictByMuniModel _resSubdistrict =
                          await ApiService().subdisctrictByMuniAPI(
                              id: newValue!.id.toString(),
                              code: newValue.code,
                              name: newValue.name,
                              desc: newValue.description);
                      setState(() {
                        dropdownMunicipality = newValue;
                        subDistrictList = _resSubdistrict.data;
                        _showsubDistrict = true;
                        _isload = false;
                      });
                    }
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: municipalityList.map((MunicipalityData item) {
                    return DropdownMenuItem<MunicipalityData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
        ),
        _showsubDistrict ? _buildDropdownsubDistrict() : Container()
      ],
    );
  }

  _buildDropdownsubDistrict() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(headers[5].key.toString() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<SubdisctrictByMuniData>(
                  isExpanded: true,
                  value: dropdownsubDistrict,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (SubdisctrictByMuniData? newValue) async {
                    if (dropdownsubDistrict != null) {
                      setState(() {
                        _isload = true;
                      });
                      VillageBySubModel _resVillage = await ApiService()
                          .villageBySubAPI(
                              id: newValue!.id,
                              code: newValue.code,
                              desc: newValue.description,
                              name: newValue.name);
                      setState(() {
                        dropdownVillage = null;
                        dropdownsubVillage = null;
                        dropdownsubDistrict = newValue;
                        villageList = _resVillage.data;
                        _showsubDistrict = true;
                        _showvillage = true;
                        _showsubVillage = false;
                        _isload = false;
                      });
                    } else {
                      setState(() {
                        _isload = true;
                      });
                      VillageBySubModel _resVillage = await ApiService()
                          .villageBySubAPI(
                              id: newValue!.id,
                              code: newValue.code,
                              desc: newValue.description,
                              name: newValue.name);
                      setState(() {
                        dropdownsubDistrict = newValue;
                        villageList = _resVillage.data;
                        _showvillage = true;
                        _isload = false;
                      });
                    }
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: subDistrictList.map((SubdisctrictByMuniData item) {
                    return DropdownMenuItem<SubdisctrictByMuniData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
        ),
        _showvillage ? _buildDropdownVillage() : Container()
      ],
    );
  }

  _buildDropdownVillage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(headers[6].key.toString() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<VillageBySubData>(
                  isExpanded: true,
                  value: dropdownVillage,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (VillageBySubData? newValue) async {
                    if (dropdownVillage != null) {
                      setState(() {
                        _isload = true;
                      });
                      SubvillageModel _resSubvillage =
                          await ApiService().subvillageAPI();
                      setState(() {
                        dropdownsubVillage = null;
                        dropdownVillage = newValue!;
                        subVillageList = _resSubvillage.data;
                        _showsubDistrict = true;
                        _showvillage = true;
                        _showsubVillage = true;
                        _isload = false;
                      });
                    } else {
                      setState(() {
                        _isload = true;
                      });
                      SubvillageModel _resSubvillage =
                          await ApiService().subvillageAPI();
                      setState(() {
                        dropdownVillage = newValue!;
                        subVillageList = _resSubvillage.data;
                        _showsubVillage = true;
                        _isload = false;
                      });
                    }
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: villageList.map((VillageBySubData item) {
                    return DropdownMenuItem<VillageBySubData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
        ),
        _showsubVillage ? _buildDropdownsubVillage() : Container()
      ],
    );
  }

  _buildDropdownsubVillage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(headers[7].key.toString() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<SubvillageData>(
                  isExpanded: true,
                  value: dropdownsubVillage,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (SubvillageData? newValue) {
                    setState(() {
                      dropdownsubVillage = newValue!;
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: subVillageList.map((SubvillageData item) {
                    return DropdownMenuItem<SubvillageData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
        ),
      ],
    );
  }
}
