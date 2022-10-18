class QuestionFields {
  // database table
  static const questionTable = 'question';

  // database column
  static const id = 'id';
  static const formType = 'formType';
  static const kode_soal = 'kode_soal';
  static const input_type = 'input_type';
  static const  question = 'question';
  static const dropdown = 'dropdown';
}

class QuestionDbModel {
  int? id;
  String? formType;
  int? kode_soal;
  String? input_type;
  String? question;
  String? dropdown;

  QuestionDbModel({this.id, this.formType, this.kode_soal, this.input_type, this.question, this.dropdown});

  factory QuestionDbModel.fromJson(Map<String, dynamic> json) {
    return QuestionDbModel(
      id: json['id'],
      formType: json['formType'],
      kode_soal: json['kode_soal'],
      input_type: json['input_type'],
      question: json['question'],
      dropdown: json['dropdown'],

    );
  }

  Map<String, dynamic> toJson() => {
    QuestionFields.id: id,
    QuestionFields.formType: formType,
    QuestionFields.kode_soal: kode_soal,
    QuestionFields.input_type: input_type,
    QuestionFields.question: question,
    QuestionFields.dropdown: dropdown,

  };
}
