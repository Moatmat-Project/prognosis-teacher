part of 'explore_outer_tests_cubit.dart';

sealed class ExploreOuterTestsState extends Equatable {
  const ExploreOuterTestsState();

  @override
  List<Object> get props => [];
}

final class ExploreOuterTestsLoading extends ExploreOuterTestsState {}

final class ExploreOuterTestsInitial extends ExploreOuterTestsState {
  final List<OuterTest> tests;

  const ExploreOuterTestsInitial({required this.tests});

  @override
  List<Object> get props => [tests];
}
