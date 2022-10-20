import 'dart:convert';

import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/formtabelModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/database/content.dart';

class FormTableDatabase {
  static final FormTableDatabase instance = FormTableDatabase.init();

  static Database? _database;

  FormTableDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('formDb.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final intType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableFormTable (
    ${FormFields.idDb} $idType,
    ${FormFields.id} $intType,
    ${FormFields.code} $textType,
    ${FormFields.title} $textType,
    ${FormFields.description} $textType,
    ${FormFields.formType} $textType
    )''');

    await db.execute('''CREATE TABLE ${HeaderFields.header} (
    ${HeaderFields.id} $idType,
    ${HeaderFields.formType} $textType,
    ${HeaderFields.key} $textType,
    ${HeaderFields.value} $textType
    )''');

    await db.execute('''CREATE TABLE ${QuestionFields.questionTable} (
    ${QuestionFields.id} $idType,
    ${QuestionFields.formType} $textType,
    ${QuestionFields.kode_soal} $intType,
    ${QuestionFields.input_type} $textType,
    ${QuestionFields.question} $textType,
    ${QuestionFields.dropdown} $textType
    )''');

    await db.execute('''CREATE TABLE ${ContentFields.table} (
    ${ContentFields.id} $idType,
    ${ContentFields.formType} $textType,
    ${ContentFields.key} $textType,
    ${ContentFields.value} $textType,
    ${ContentFields.code} $textType
    )''');
  }

  Future<FormModel> createForm(FormModel form) async {
    final db = await instance.database;

    final id = await db.insert(tableFormTable, form.toJson());
    return form.copy(id: id);
  }

  Future<int> create(String table, HeaderDatabaseModel model) async {
    final db = await instance.database;
    final query = await db.insert(table, model.toJson());

    return query;
  }

  Future<int> createQuestion(String table, QuestionDbModel model) async {
    final db = await instance.database;
    final query = await db.insert(table, model.toJson());

    return query;
  }

  Future<FormModel> read(int? id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableFormTable,
      columns: FormFields.values,
      where: '${FormFields.idDb} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FormModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<HeaderDatabaseModel>> readHeader(String? type) async {
    final db = await instance.database;

    final maps = await db.query(HeaderFields.header,
        where: '${HeaderFields.formType} = ?', whereArgs: [type]);

    if (maps.isNotEmpty) {
      return maps.map((json) => HeaderDatabaseModel.fromJson(json)).toList();
    } else {
      throw Exception('ID $type not found');
    }
  }

  Future<List<QuestionDbModel>> readQuestion(String? type) async {
    final db = await instance.database;

    final maps = await db.query(QuestionFields.questionTable,
        where: '${QuestionFields.formType} = ?', whereArgs: [type]);

    if (maps.isNotEmpty) {
      return maps.map((json) => QuestionDbModel.fromJson(json)).toList();
    } else {
      throw Exception('ID $type not found');
    }
  }

  Future<List<FormModel>> readAll() async {
    final db = await instance.database;

    final result = await db.query(tableFormTable);

    return result.map((json) => FormModel.fromJson(json)).toList();
  }

  // content

  Future<int> createContent(String table, ContentDatabaseModel model) async {
    final db = await instance.database;
    final query = await db.insert(table, model.toJson());

    return query;
  }

  Future<List<ContentDatabaseModel>> readContent(String? type) async {
    final db = await instance.database;

    final maps = await db.query(ContentFields.table,
        where: '${ContentFields.formType} = ?', whereArgs: [type]);

    if (maps.isNotEmpty) {
      return maps.map((json) => ContentDatabaseModel.fromJson(json)).toList();
    } else {
      throw Exception('ID $type not found');
    }
  }

  Future<List<ContentDatabaseModel>> contentReadAll() async {
    Database db = await instance.database;
    final data = await db.query(ContentFields.table, groupBy: ContentFields.code);
    List<ContentDatabaseModel> result = data.map((e) => ContentDatabaseModel.fromJson(e)).toList();

    return result;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
