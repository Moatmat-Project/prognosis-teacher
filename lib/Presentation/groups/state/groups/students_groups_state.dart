part of 'students_groups_cubit.dart';

sealed class StudentsGroupsState extends Equatable {
  const StudentsGroupsState();

  @override
  List<Object> get props => [];
}

final class StudentsGroupsLoading extends StudentsGroupsState {}

final class StudentsGroupsError extends StudentsGroupsState {
  final String error;

  const StudentsGroupsError({required this.error});
}

final class StudentsGroupsInitial extends StudentsGroupsState {
  final List<Group> groups;

  const StudentsGroupsInitial({
    required this.groups,
  });

  @override
  List<Object> get props => [groups];
}
