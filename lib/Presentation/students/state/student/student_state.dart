part of 'student_cubit.dart';

sealed class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

final class StudentLoading extends StudentState {}

final class StudentError extends StudentState {
  final String error;

  const StudentError({required this.error});
}

final class StudentInitial extends StudentState {
  final UserData userData;
  final List<Result> results;

  const StudentInitial({required this.results, required this.userData});

  @override
  List<Object> get props => [results, userData];
}

final class StudentResultDetails extends StudentState {
  final OuterTest? outerTest;
  final Test? test;
  final Bank? bank;
  final double? testAverage;
  final List<(Question?, int?)> wrongAnswers;
  final Result result;
  final UserData userData;

  const StudentResultDetails({
    required this.outerTest,
    required this.test,
    required this.bank,
    required this.testAverage,
    required this.result,
    required this.userData,
    required this.wrongAnswers,
  });

  @override
  List<Object?> get props => [
        test,
        bank,
        testAverage,
        wrongAnswers,
        result,
        userData,
      ];
}
