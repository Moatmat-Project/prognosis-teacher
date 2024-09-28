import 'package:moatmat_teacher/Features/banks/domain/entities/bank_properties.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';

import 'bank_information.dart';

class Bank {
  final int id;
  final String teacherEmail;
  final BankInformation information;
  final BankProperties properties;
  final List<Question> questions;
  Bank({
    required this.id,
    required this.teacherEmail,
    required this.information,
    required this.properties,
    required this.questions,
  });

  Bank copyWith({
    int? id,
    String? teacherEmail,
    BankInformation? information,
    BankProperties? properties,
    List<Question>? questions,
  }) {
    return Bank(
      id: id ?? this.id,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      information: information ?? this.information,
      properties: properties ?? this.properties,
      questions: questions ?? this.questions,
    );
  }
}
