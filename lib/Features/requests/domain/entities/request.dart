import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/teachers/domain/entities/teacher.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

class TeacherRequest {
  //
  int id;
  //
  final TeacherData teacherData;
  //
  final String? text;
  //
  final Bank? bank;
  //
  final Test? test;
  //
  final List<String> files;
  //
  final DateTime date;

  TeacherRequest({
    required this.id,
    this.text,
    required this.teacherData,
    this.bank,
    this.test,
    required this.files,
    required this.date,
  });

  TeacherRequest copyWith({
    //
    int? id,
    //
    String? text,
    //
    TeacherData? teacherData,
    //
    Bank? bank,
    //
    Test? test,
    //
    List<String>? files,
    //
    DateTime? date,
  }) {
    return TeacherRequest(
      id: id ?? this.id,
      text: text ?? this.text,
      teacherData: teacherData ?? this.teacherData,
      bank: bank ?? this.bank,
      test: test ?? this.test,
      files: files ?? this.files,
      date: date ?? this.date,
    );
  }
}
