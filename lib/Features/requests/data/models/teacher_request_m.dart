import 'package:moatmat_teacher/Features/auth/data/models/teacher_data_m.dart';
import 'package:moatmat_teacher/Features/banks/data/models/bank_m.dart';
import 'package:moatmat_teacher/Features/tests/data/models/test_m.dart';

import '../../domain/entities/request.dart';

class TeacherRequestModel extends TeacherRequest {
  TeacherRequestModel({
    required super.id,
    required super.text,
    required super.teacherData,
    required super.bank,
    required super.test,
    required super.files,
    required super.date,
  });

  factory TeacherRequestModel.fromJson(Map json) {
    return TeacherRequestModel(
      id: json["id"],
      text: json["text"],
      teacherData: TeacherDataModel.fromJson(json["teacher_data"]),
      bank: json["bank"] != null ? BankModel.fromJson(json["bank"]) : null,
      test: json["test"] != null ? TestModel.fromJson(json["test"]) : null,
      files: json["files"].cast<String>(),
      date: DateTime.parse(json["date"]),
    );
  }

  factory TeacherRequestModel.fromClass(TeacherRequest request) {
    return TeacherRequestModel(
      id: request.id,
      text: request.text,
      teacherData: request.teacherData,
      bank: request.bank,
      test: request.test,
      files: request.files,
      date: request.date,
    );
  }

  toJson() {
    var data = {
      "text": text,
      "teacher_data": TeacherDataModel.fromClass(teacherData).toJson(),
      "files": files,
      "date": date.toString(),
    };
    //
    if (bank != null) {
      data["bank"] = BankModel.fromClass(bank!).toJson();
    }
    //
    if (test != null) {
      data["test"] = TestModel.fromClass(test!).toJson();
    }
    //
    return data;
  }
}
