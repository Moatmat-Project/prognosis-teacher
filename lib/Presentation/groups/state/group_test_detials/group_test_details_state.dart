part of 'group_test_details_cubit.dart';

sealed class GroupTestDetailsState extends Equatable {
  const GroupTestDetailsState();

  @override
  List<Object> get props => [];
}

final class GroupTestDetailsLoading extends GroupTestDetailsState {}

final class GroupTestDetailsError extends GroupTestDetailsState {
  final Failure? failure;

  const GroupTestDetailsError({required this.failure});
}

final class GroupTestDetailsPickGroup extends GroupTestDetailsState {
  final List<Group> groups;

  const GroupTestDetailsPickGroup({required this.groups});
}

final class GroupTestDetailsInitial extends GroupTestDetailsState {
  final Test? test;
  final Bank? bank;
  final OuterTest? outerTest;
  final List<(Result?, UserData)> results;
  final RepositoryDetails details;

  const GroupTestDetailsInitial({
    required this.test,
    required this.bank,
    required this.outerTest,
    required this.results,
    required this.details,
  });
  @override
  List<Object> get props => [results, details];
}
