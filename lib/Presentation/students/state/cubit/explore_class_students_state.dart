part of 'explore_class_students_cubit.dart';

sealed class ExploreClassStudentsState extends Equatable {
  const ExploreClassStudentsState();

  @override
  List<Object> get props => [];
}

final class ExploreClassStudentsLoading extends ExploreClassStudentsState {}

final class ExploreClassStudentsInitial extends ExploreClassStudentsState {
  final List<UserData> users;

  const ExploreClassStudentsInitial({required this.users});

  @override
  List<Object> get props => [users];
}
