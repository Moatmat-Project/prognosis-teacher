import 'test_information.dart';
import 'test_properties.dart';
import '../question/question.dart';

class Test {
  final int id;
  final String teacherEmail;
  final TestInformation information;
  final TestProperties properties;
  final List<Question> questions;
  

  Test({
    required this.id,
    required this.teacherEmail,
    required this.information,
    required this.properties,
    required this.questions,
  });
  Test copyWith({
    int? id,
    String? teacherEmail,
    TestInformation? information,
    TestProperties? properties,
    List<Question>? questions,
  }) {
    return Test(
      id: id ?? this.id,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      information: information ?? this.information,
      properties: properties ?? this.properties,
      questions: questions ?? this.questions,
    );
  }
}
