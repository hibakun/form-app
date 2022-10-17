class HeaderFields {
  // database table
  static const header = 'header';

  // database column
  static const id = 'id';
  static const formType = 'formType';
  static const key = 'key';
  static const value = 'value';
}

class HeaderDatabaseModel {
  int? id;
  String? formType;
  String? key;
  String? value;

  HeaderDatabaseModel({this.id, this.formType, this.key, this.value});

  factory HeaderDatabaseModel.fromJson(Map<String, dynamic> json) {
    return HeaderDatabaseModel(
      id: json['id'],
      formType: json['formType'],
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        HeaderFields.id: id,
        HeaderFields.formType: formType,
        HeaderFields.key: key,
        HeaderFields.value: value,
      };
}
