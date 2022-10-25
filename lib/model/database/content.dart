class ContentFields {
  // database table
  static const table = 'content';

  // database column
  static const id = 'id';
  static const formType = 'formType';
  static const key = 'key';
  static const value = 'value';
  static const code = 'transId';
}

class ContentDatabaseModel {
  int? id;
  String? formType;
  String? key;
  String? value;
  String? code;

  ContentDatabaseModel(
      {this.id, this.formType, this.key, this.value, this.code});

  factory ContentDatabaseModel.fromJson(Map<String, dynamic> json) {
    return ContentDatabaseModel(
      id: json['id'],
      formType: json['formType'],
      key: json['key'],
      value: json['value'],
      code: json['transId'],
    );
  }

  Map<String, dynamic> toJson() => {
        ContentFields.id: id,
        ContentFields.formType: formType,
        ContentFields.key: key,
        ContentFields.value: value,
        ContentFields.code: code,
      };
}
