part of 'outer_test_results_cubit.dart';

sealed class OuterTestResultsState extends Equatable {
  const OuterTestResultsState();

  @override
  List<Object> get props => [];
}

final class OuterTestResultsLoading extends OuterTestResultsState {
  const OuterTestResultsLoading();
}

final class OuterTestResultsError extends OuterTestResultsState {
  final String details;
  const OuterTestResultsError(this.details);
}

final class OuterTestResultsInitial extends OuterTestResultsState {
  final RepositoryDetails details;

  const OuterTestResultsInitial({required this.details});
}
