part of 'create_question_cubit.dart';

sealed class CreateQuestionState extends Equatable {
  const CreateQuestionState();
}

final class CreateQuestionLoading extends CreateQuestionState {
  @override
  List<Object?> get props => [];
}

final class CreateQuestionInitial extends CreateQuestionState {
  final Question question;

  const CreateQuestionInitial({required this.question});

  @override
  List<Object> get props => [question];
}

final class CreateQuestionSetUpAnswers extends CreateQuestionState {
  
  final List<Answer> answers;

  const CreateQuestionSetUpAnswers({required this.answers});

  @override
  List<Object> get props => [answers];
}
