import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_question.dart';

class OuterTestForm {
  final int id;
  final List<OuterQuestion> questions;

  OuterTestForm({
    required this.id,
    required this.questions,
  });

  OuterTestForm copyWith({
    int? id,
    List<OuterQuestion>? questions,
  }) {
    return OuterTestForm(
      id: id ?? this.id,
      questions: questions ?? this.questions,
    );
  }
}
