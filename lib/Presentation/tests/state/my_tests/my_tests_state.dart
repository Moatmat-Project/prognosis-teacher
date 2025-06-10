part of 'my_tests_cubit.dart';

sealed class MyTestsState extends Equatable {
  const MyTestsState();

  @override
  List<Object> get props => [];
}

final class MyTestsLoading extends MyTestsState {}

final class MyTestsError extends MyTestsState {
  final Exception exception;

  const MyTestsError({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class MyTestsInitial extends MyTestsState {
  final List<Test> tests;
  const MyTestsInitial({required this.tests});

  @override
  List<Object> get props => [tests];
}
