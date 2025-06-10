part of 'test_results_cubit.dart';

sealed class TestResultsState extends Equatable {
  const TestResultsState();

  @override
  List<Object> get props => [];
}

final class TestResultsLoading extends TestResultsState {
  const TestResultsLoading();
}

final class TestResultsError extends TestResultsState {
  final String details;
  const TestResultsError(this.details);
}

final class TestResultsInitial extends TestResultsState {
  final RepositoryDetails details;

  const TestResultsInitial({required this.details});
}
