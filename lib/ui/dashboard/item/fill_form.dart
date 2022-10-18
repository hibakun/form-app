import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/shared_code.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/municipality_model.dart';
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
  String? dropdownMunicipality;
  List? municipalityList;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _selectedDate = DateTime.now();
  String _selectDate = "";
  final _nameController = TextEditingController();
  bool _isload = false;
  bool _showsubDistrict = false;
  bool _showvillage = false;
  bool _showsubVillage = false;
  List<HeaderDatabaseModel> headers = [];
  List<QuestionDbModel> questions = [];

  read() async {
    setState(() {
      _isload = true;
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
    MunicipalityModel result = await ApiService().municipalityAPI();
    setState(() {
      municipalityList = result.data;
      _isload = false;
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
          body: _isload
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: _buildDatePickerField(),
                      ),
                      SizedBox(height: 20.h),
                      _buildDropdownMunicipality(),
                      _showsubDistrict
                          ? _buildDropdownsubDistrict()
                          : _showsubVillage
                              ? _buildDropdownVillage()
                              : _showsubVillage
                                  ? _buildDropdownsubVillage()
                                  : Container()
                    ],
                  ),
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
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownMunicipality,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownMunicipality = newValue!;
                      _showsubDistrict = true;
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: municipalityList!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item.code.toString(),
                    );
                  }).toList(),
                )),
          ),
        ),
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
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownMunicipality,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownMunicipality = newValue!;
                      _showvillage = true;
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: municipalityList!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item.code.toString(),
                    );
                  }).toList(),
                )),
          ),
        ),
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
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownMunicipality,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownMunicipality = newValue!;
                      _showsubVillage = true;
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: municipalityList!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item.code.toString(),
                    );
                  }).toList(),
                )),
          ),
        ),
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
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownMunicipality,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownMunicipality = newValue!;
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: municipalityList!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item.code.toString(),
                    );
                  }).toList(),
                )),
          ),
        ),
      ],
    );
  }
}
