import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/answer.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';

part 'create_question_state.dart';

class CreateQuestionCubit extends Cubit<CreateQuestionState> {
  CreateQuestionCubit() : super(CreateQuestionLoading());
  late Question question;

  init({Question? q}) {
    question = const Question(
      id: 0,
      lowerImageText: null,
      upperImageText: null,
      image: null,
      video: null,
      explain: null,
      period: null,
      explainImage: null,
      editable: null,
      answers: [],
      equations: [],
      colors: [],
    );
    if (q != null) {
      question = q;
    }
    emit(CreateQuestionInitial(question: question));
  }

  addAnswer(Answer answer) {
    List<Answer> newList = List<Answer>.from(question.answers)..add(answer);
    question = question.copyWith(answers: newList);
    emit(CreateQuestionSetUpAnswers(answers: newList));
  }

  removeAnswer(int index) {
    //
    if (index < 0 || index >= question.answers.length) {
      emit(CreateQuestionSetUpAnswers(answers: question.answers));
      return;
    }
    List<Answer> newList = List<Answer>.from(question.answers)..removeAt(index);
    //
    question = question.copyWith(answers: newList);
    //
    emit(CreateQuestionSetUpAnswers(answers: newList));
  }

  updateAnswer(int index, Answer answer) {
    //
    if (index < 0 || index >= question.answers.length) {
      emit(CreateQuestionSetUpAnswers(answers: question.answers));
      return;
    }
    //
    List<Answer> newList = List<Answer>.from(question.answers);
    newList[index] = answer;
    //
    question = question.copyWith(answers: newList);
    //
    emit(CreateQuestionSetUpAnswers(answers: newList));
  }

  //
  updateQuestion(Question question) {
    this.question = question;
    emit(CreateQuestionInitial(question: question));
  }
  //

  //
  emitSetUpAnswers() {
    emit(CreateQuestionSetUpAnswers(answers: question.answers));
  }

  //
  emitSetUpQuestion() {
    emit(CreateQuestionInitial(question: question));
  }
}
