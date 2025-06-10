import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_question.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';

import '../../../tests/domain/entities/question/question.dart';
import '../../../tests/domain/entities/test/test.dart';
import '../../domain/entities/result.dart';
import '../../domain/entities/test_details.dart';

abstract class StudentsLocalDS {
  RepositoryDetails getRepositoryDetails({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required List<Result> results,
  });
}

class StudentsLocalDSImpl implements StudentsLocalDS {
  const StudentsLocalDSImpl();
  @override
  RepositoryDetails getRepositoryDetails({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required List<Result> results,
  }) {
    //
    List<(Result, double)> marks = [];
    //
    List<Question> questions = [];
    //
    if (test != null) {
      questions = test.questions;
    }
    if (outerTest != null) {
      questions = outerTest.forms.first.questions.map((e) => e.toQuestion()).toList();
    }

    if (bank != null) {
      questions = bank.questions;
    }
    //
    List<Map<int, int>> selectionCounts = questions.map((e) {
      return <int, int>{};
    }).toList();
    //
    for (int i = 0; i < results.length; i++) {
      //
      final r = results[i];
      //
      final double m;
      if (outerTest != null) {
        m = calculateOuterTestMarkFunction(result: r, test: outerTest);
      } else {
        m = calculateMarkFunction(result: results[i], questions: questions);
      }
      //
      marks.add((r, m));
      //
    }
    // {questions id : selections}
    // {q0: [0, 1, 0], q1: [0, 0, 0], q2: [0, 1, 1]}
    // where [0,1,..] is answers
    Map<int, List<int>> selectionsData = getSelectionsData(
      results,
    );
    // {questions id : selections}
    // {q0: {0: 2, 1: 1}, q1:  {0: 3}, q2: {0: 1, 1: 2}}
    // where [0,1,..] is answers
    selectionCounts = getSelectionCount(
      selectionsData: selectionsData,
      selectionCounts: selectionCounts,
    );

    // {q0: [2, 1], q1: [3, 0], q2: [1, 2]}
    // where [2, 1,..] is answers selection counts
    List<List<int>> selectionsCount = fixSelectionsCount(
      selectionCounts: selectionCounts,
      questions: questions,
      isOuterTest: outerTest != null,
    );

    // selectionsCount
    List<List<double>> selectionPercents = [];
    //
    for (var c in selectionsCount) {
      List<double> values = [];
      int sum = c.reduce((a, b) => a + b);
      if (sum == 0) {
        // If sum is zero, use 0.0 to avoid division by zero
        values = List<double>.filled(c.length, 0.0);
      } else {
        for (var l in c) {
          values.add(double.tryParse((l / sum).toStringAsFixed(2)) ?? 0.0);
        }
      }
      selectionPercents.add(values);
    }

    //
    Map<int, int> markData = calculateMarkData(results);

    //
    return RepositoryDetails(
      averageMark: outerTest != null ? calculateOuterTestAverageMark(results: results, test: outerTest) : calculateAverageMark(results: results, questions: questions),
      averageTime: outerTest != null ? 0 : calculateAverageTime(results: results, questions: questions),
      selectionPercents: selectionPercents,
      marks: marks,
      marksData: markData,
    );
  }

  double calculateAverageMark({
    required List<Result> results,
    required List<Question> questions,
  }) {
    List<double> marks = results.map((e) {
      return calculateMarkFunction(result: e, questions: questions);
    }).toList();
    //
    marks.removeWhere((e) {
      return e < 0.3;
    });
    //
    if (marks.isEmpty) {
      // Return a default value or 0.0 if no marks are left after filtering
      return 0.0;
    }
    //
    double sum = marks.fold(0, (previous, current) => previous + current);
    //
    double average = sum / marks.length; // Now marks.length will not be zero
    //
    average = double.tryParse(average.toStringAsFixed(2)) ?? 0.0;
    //
    return average;
  }

  double calculateOuterTestAverageMark({
    required List<Result> results,
    required OuterTest test,
  }) {
    List<double> marks = results.map((e) {
      return calculateOuterTestMarkFunction(result: e, test: test);
    }).toList();
    //
    marks.removeWhere((e) {
      return e < 0.3;
    });
    //
    if (marks.isEmpty) {
      // Return a default value or 0.0 if no marks are left after filtering
      return 0.0;
    }
    //
    double sum = marks.fold(0, (previous, current) => previous + current);
    //
    double average = sum / marks.length; // Now marks.length will not be zero
    //
    average = double.tryParse(average.toStringAsFixed(2)) ?? 0.0;
    //
    return average;
  }

  double calculateAverageTime({
    required List<Result> results,
    required List<Question> questions,
  }) {
    //
    List<int> marks = results.map((e) {
      return e.period;
    }).toList();
    //
    marks.removeWhere((m) => m < 120);
    //
    double sum = marks.fold(
      0,
      (previous, current) => previous + current,
    );
    //
    if (sum <= 0) {
      return 0.0;
    }
    //
    double average = sum / results.length;
    //

    return average;
  }

  double calculateMarkFunction({required Result result, required List<Question> questions}) {
    //
    if (questions.isEmpty) return 0.0;

    //
    double currentResult = 0.0;
    //
    //
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      List<int?> correctAnswers = [];

      for (int j = 0; j < question.answers.length; j++) {
        if (question.answers[j].trueAnswer ?? false) {
          correctAnswers.add(j);
        }
      }
      // Check if the index is valid and if the selected answer is correct
      if (i < result.answers.length && correctAnswers.contains(result.answers[i])) {
        currentResult++;
      }
    }

    // Calculation of percentage of correct answers
    double percentage = currentResult / questions.length;
    // Formatting the result to two decimal places
    return double.parse(percentage.toStringAsFixed(2));
  }

  double calculateOuterTestMarkFunction({required Result result, required OuterTest test}) {
    //
    final List<OuterQuestion> questions = test.forms[result.form!].questions;
    //
    if (questions.isEmpty) return 0.0;
    //
    int currentResult = 0;
    //
    //
    for (int i = 0; i < questions.length; i++) {
      if ((result.answers[i]) == (questions[i].trueAnswer + 1)) {
        currentResult++;
      }
    }

    // Calculation of percentage of correct answers
    double percentage = currentResult / questions.length;
    // Formatting the result to two decimal places
    return double.parse(percentage.toStringAsFixed(2));
  }

  Map<int, List<int>> getSelectionsData(List<Result> results) {
    //
    Map<int, List<int>> selectionCountsData = {};
    //
    for (int i = 0; i < results.length; i++) {
      //
      for (int j = 0; j < results[i].answers.length; j++) {
        //
        var a = results[i].answers[j];
        // check
        if (selectionCountsData[j] == null) {
          selectionCountsData[j] = [];
        }
        //
        if (a != null) {
          if (results.first.form != null) {
            a = a - 1;
          }
          selectionCountsData[j]!.add(a);
        }
      }
    }
    return selectionCountsData;
  }

  List<Map<int, int>> getSelectionCount({
    required Map<int, List<int>> selectionsData,
    required List<Map<int, int>> selectionCounts,
  }) {
    for (var key in selectionsData.keys) {
      //
      Map<int, int> selections = {};
      //
      for (var d in selectionsData[key]!) {
        //
        if (selections[d] == null) {
          selections[d] = 0;
        }
        //
        selections[d] = selections[d]! + 1;
      }
      //
      if (key < 0 || key >= selectionCounts.length) {
        continue;
      }
      selectionCounts[key] = selections;
    }
    return selectionCounts;
  }

  List<List<int>> fixSelectionsCount({
    required List<Map<int, int>> selectionCounts,
    required List<Question> questions,
    bool isOuterTest = false,
  }) {
    //
    List<List<int>> selectionsCount = [];
    //
    for (int i = 0; i < selectionCounts.length; i++) {
      //
      List<int> values = [];
      //
      values = questions[i].answers.map((e) => 0).toList();
      //
      int valuesLength = values.length;
      //
      for (var v in selectionCounts[i].keys) {
        if (v < (valuesLength)) {
          values[v] = selectionCounts[i][v]!;
        } else {
          // skip;
        }
      }
      //
      selectionsCount.add(values);
    }
    return selectionsCount;
  }

  Map<int, int> calculateMarkData(List<Result> marks) {
    //
    Map<int, int> markData = {};
    //
    List<int> dMarks = [];
    //
    dMarks = marks.map((e) => e.mark.toInt()).toList();
    //
    dMarks.sort((a, b) => a.compareTo(b));
    //
    // {"mark" : count of mark accuracy}
    for (var m in dMarks) {
      //
      if (markData[m] == null) {
        markData[m] = 0;
      }
      //
      markData[m] = markData[m]! + 1;
    }
    //
    List<int> keys = markData.keys.toList();
    //
    for (int i = 1; i < keys.length; i++) {
      markData[keys[i]] = markData[keys[i]]! + markData[keys[i - 1]]!;
    }
    //
    return markData;
  }
}
