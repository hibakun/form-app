class QuestionAnswerFields {
  // database table
  static const questionanswerTable = 'question_answer';

  // database column
  static const id = 'id';
  static const formType = 'formType';
  static const id_soal = 'id_soal';
  static const question = 'question';
  static const dropdown = 'dropdown';
  static const answer = 'answer';
  static const code = 'code';
}

class QuestionAnswerDbModel {
  int? id;
  String? formType;
  int? id_soal;
  String? question;
  String? dropdown;
  String? code;
  String? answer;


  QuestionAnswerDbModel({this.id, this.formType, this.id_soal, this.question, this.dropdown, this.code, this.answer});

  factory QuestionAnswerDbModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnswerDbModel(
      id: json['id'],
      formType: json['formType'],
      id_soal: json['id_soal'],
      question: json['question'],
      dropdown: json['dropdown'],
      code: json['code'],
      answer: json['answer'],

    );
  }

  Map<String, dynamic> toJson() => {
    QuestionAnswerFields.id: id,
    QuestionAnswerFields.formType: formType,
    QuestionAnswerFields.id_soal: id_soal,
    QuestionAnswerFields.question: question,
    QuestionAnswerFields.dropdown: dropdown,
    QuestionAnswerFields.answer: answer,
    QuestionAnswerFields.code: code,

  };
}
