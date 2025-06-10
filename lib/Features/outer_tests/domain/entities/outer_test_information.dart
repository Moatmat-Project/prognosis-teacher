import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';


class OuterTestInformation {
  //
  final int length;
  //
  final String title;
  //
  final String material;
  //
  final String classs;
  //
  final String teacher;
  //
  final DateTime date;
  //
  final PaperType paperType;

  OuterTestInformation({
    required this.paperType,
    required this.length,
    required this.title,
    required this.material,
    required this.classs,
    required this.teacher,
    required this.date,
  });
}
