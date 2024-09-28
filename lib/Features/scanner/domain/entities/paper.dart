// ignore_for_file: constant_identifier_names

import 'package:moatmat_teacher/Features/scanner/domain/entities/answers_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/form_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/id_data.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

class Paper {
  //
  double? mark;
  final UserData? student;
  final PaperData data;
  final PaperSettings settings;
  //
  Paper({
    this.student,
    required this.data,
    required this.settings,
  });
  //
  List<int?> getSelections() {
    //
    List<int?> selections = [];
    //
    for (var row in data.answers.rows) {
      selections.add(row.selected);
    }
    //
    return selections;
  }

  //
  List<int?> getWrongSelections() {
    //
    int form = data.form.row.selected ?? 0;
    //
    List<int> answers = settings.answers[form];
    //
    List<int?> wrongSelections = [];
    //
    for (int i = 0; i < answers.length; i++) {
      if (data.answers.rows[i].selected != answers[i] + 1) {
        wrongSelections.add(data.answers.rows[i].selected);
      } else {
        wrongSelections.add(-1);
      }
    }
    //
    return wrongSelections;
  }

  //
  double getMark() {
    //
    int form = data.form.row.selected ?? 0;
    //
    List<int> answers = settings.answers[form];
    //
    int trueAnswers = 0;
    //
    for (int i = 0; i < answers.length; i++) {
      if (data.answers.rows[i].selected == answers[i] + 1) {
        trueAnswers++;
      }
    }
    //
    mark = trueAnswers / answers.length;
    //
    return (trueAnswers / answers.length) * 100;
  }

  Paper copyWith({
    UserData? student,
    int? testId,
  }) {
    return Paper(
      student: student ?? this.student,
      data: data,
      settings: settings,
    );
  }
}

class PaperSettings {
  final String title;
  final DateTime date;
  final PaperType type;
  final List<int?> selections;
  final List<List<int>> answers;
  final int formsCount;

  PaperSettings({
    required this.title,
    required this.date,
    required this.type,
    required this.selections,
    required this.answers,
    required this.formsCount,
  });

  PaperSettings copyWith({
    String? title,
    DateTime? date,
    PaperType? type,
    List<int?>? selections,
    List<List<int>>? answers,
    int? formsCount,
  }) {
    return PaperSettings(
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      selections: selections ?? this.selections,
      answers: answers ?? this.answers,
      formsCount: formsCount ?? this.formsCount,
    );
  }
}

class PaperData {
  final IdData id;
  final AnswersData answers;
  final FormData form;

  PaperData({
    required this.id,
    required this.answers,
    required this.form,
  });
}

enum PaperType { A4, A5, A6 }
