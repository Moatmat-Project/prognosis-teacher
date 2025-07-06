part of 'my_students_cubit.dart';

sealed class MyStudentsState extends Equatable {
  const MyStudentsState();

  @override
  List<Object> get props => [];
}

final class MyStudentsLoading extends MyStudentsState {}

final class MyStudentsError extends MyStudentsState {
  final String error;

  const MyStudentsError({required this.error});
}

final class MyStudentsInitial extends MyStudentsState {
  final List<UserData> users;
  final List<int> testsIds;
  final List<UserData> selectedUsers;

  const MyStudentsInitial({
    required this.users,
    required this.testsIds,
    required this.selectedUsers
  });

  @override
  List<Object> get props => [users];
}
