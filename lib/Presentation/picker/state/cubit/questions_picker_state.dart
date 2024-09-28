part of 'questions_picker_cubit.dart';

sealed class QuestionsPickerState extends Equatable {
  const QuestionsPickerState();

  @override
  List<Object?> get props => [];
}

final class QuestionsPickerLoading extends QuestionsPickerState {}

final class QuestionsPickerTeacher extends QuestionsPickerState {
  final List<String> teachers;

  const QuestionsPickerTeacher({required this.teachers});

  @override
  List<Object?> get props => teachers;
}

final class QuestionsPickerRepository extends QuestionsPickerState {
  final String teacher;

  const QuestionsPickerRepository({
    required this.teacher,
  });
  @override
  List<Object?> get props => [teacher];
}

final class QuestionsPickerQuestions extends QuestionsPickerState {
  final List<Question> questions;

  const QuestionsPickerQuestions({required this.questions});

  @override
  List<Object?> get props => [questions];
}
