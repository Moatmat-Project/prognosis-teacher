import 'package:flutter/cupertino.dart';
import 'package:moatmat_teacher/Features/tests/data/models/question_m.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test_information.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test_properties.dart';

import '../../domain/entities/test/test.dart';
import 'test_information_m.dart';
import 'test_properties_m.dart';

class TestModel extends Test {
  TestModel({
    required super.id,
    required super.teacherEmail,
    required super.information,
    required super.properties,
    required super.questions,
  });
  factory TestModel.fromJson(Map json) {
    return TestModel(
      id: json['id'] ?? 0,
      teacherEmail: json['teacher_email'],
      information: TestInformationModel.fromJson(json['information']),
      properties: TestPropertiesModel.fromJson(json['properties']),
      questions: List.generate(
        (json['questions'] as List).length,
        (i) => QuestionModel.fromJson(json['questions'][i]),
      ),
    );
  }
  factory TestModel.fromJsonForId(Map json) {
    return TestModel(
      id: json['id'] ?? 0,
      teacherEmail: "",
      information: TestInformation.empty().copyWith(title: json['title']),
      properties: TestProperties.empty(),
      questions: [],
    );
  }

  factory TestModel.fromClass(Test test) {
    return TestModel(
      id: test.id,
      teacherEmail: test.teacherEmail,
      information: TestInformationModel.fromClass(test.information),
      properties: test.properties,
      questions: test.questions,
    );
  }
  toJson() {
    return {
      "teacher_email": teacherEmail,
      "information": TestInformationModel.fromClass(information).toJson(),
      "properties": TestPropertiesModel.fromClass(properties).toJson(),
      "questions": List.generate(
        questions.length,
        (i) => QuestionModel.fromClass(questions[i]).toJson(),
      ),
    };
  }

  toJsonWithId() {
    return {
      "id": id,
      "teacher_email": teacherEmail,
      "information": TestInformationModel.fromClass(information).toJson(),
      "properties": TestPropertiesModel.fromClass(properties).toJson(),
      "questions": List.generate(
        questions.length,
        (i) => QuestionModel.fromClass(questions[i]).toJson(),
      ),
    };
  }
}
