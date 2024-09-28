import 'dart:convert';

import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/tests/data/models/question_m.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsCashS {
  //
  static Future<void> cashQuestions(
      List<Question> questions, String repository) async {
    //
    List jsonQ = questions.map((e) {
      return QuestionModel.fromClass(e).toJson();
    }).toList();
    //
    String strQ = json.encode(jsonQ);
    //
    await locator<SharedPreferences>()
        .setString("cashed_questions_$repository", strQ);
    //
    return;
  }

  //
  static Future clearQuestions(String repository) async {
    print("dfd");
    //
    await locator<SharedPreferences>().remove("cashed_questions_$repository");
    //
    return;
  }

  //
  static bool canLoadQuestions(String repository) {
    //
    String? strQ =
        locator<SharedPreferences>().getString("cashed_questions_$repository");
    //
    //
    return strQ != null;
  }

  //
  static Future<List<Question>> loadQuestions(String repository) async {
    //
    String? strQ =
        locator<SharedPreferences>().getString("cashed_questions_$repository");
    //
    if (strQ == null) return [];
    //
    List jsonQ = json.decode(strQ);
    //
    List<Question> questions = jsonQ.map((e) {
      return QuestionModel.fromJson(e);
    }).toList();
    //
    return questions;
  }
}
