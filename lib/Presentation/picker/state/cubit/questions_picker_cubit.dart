import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

part 'questions_picker_state.dart';

class QuestionsPickerCubit extends Cubit<QuestionsPickerState> {
  QuestionsPickerCubit() : super(QuestionsPickerLoading());
  //
  late List<Question> questions;
  //
  late String currentTeacher;
  late bool isTest;

  init() async {
    //
    questions = [];
    //
    emit(QuestionsPickerLoading());
    //
    setTeacher(locator<TeacherData>().email);
  }

  //
  pickTeacher() async {
    emit(QuestionsPickerLoading());
    //
    emit(QuestionsPickerRepository(
      teacher: locator<TeacherData>().email,
    ));
  }

  //
  setTeacher(String email) {
    //
    currentTeacher = email;
    //
    pickRepository();
  }

  //
  pickRepository() {
    //
    emit(QuestionsPickerLoading());
    //
    emit(QuestionsPickerRepository(teacher: currentTeacher));
  }

  setRepository({Bank? bank, Test? test}) {
    emit(QuestionsPickerQuestions(
      questions: bank?.questions ?? test!.questions,
    ));
  }

  //
  //
  addQuestion(Question q) {
    questions.add(q);
  }

  //
}
