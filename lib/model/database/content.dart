class ContentFields {
  // database table
  static const table = 'content';

  // database column
  static const id = 'id';
  static const formType = 'formType';
  static const key = 'key';
  static const value = 'value';
  static const code = 'transId';
  static const dropdownId = 'dropdownId';
  static const status = 'status';
}

class ContentDatabaseModel {
  int? id;
  String? formType;
  String? key;
  String? value;
  String? code;
  int? status;
  int? dropdownId;

  ContentDatabaseModel(
      {this.id, this.formType, this.key, this.value, this.code, this.dropdownId, this.status});

  factory ContentDatabaseModel.fromJson(Map<String, dynamic> json) {
    return ContentDatabaseModel(
      id: json['id'],
      formType: json['formType'],
      value: json['value'],
      key: json['key'],
      code: json['transId'],
      dropdownId: json['dropdownId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        ContentFields.id: id,
        ContentFields.formType: formType,
        ContentFields.key: key,
        ContentFields.value: value,
        ContentFields.code: code,
        ContentFields.status: status,
        ContentFields.dropdownId: dropdownId,
      };
}
