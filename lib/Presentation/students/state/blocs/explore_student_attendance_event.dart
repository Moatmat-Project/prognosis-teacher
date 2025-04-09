part of 'explore_student_attendance_bloc.dart';

sealed class ExploreStudentAttendanceEvent extends Equatable {
  const ExploreStudentAttendanceEvent();

  @override
  List<Object> get props => [];
}

final class LoadStudentAttendanceEvent extends ExploreStudentAttendanceEvent {
  const LoadStudentAttendanceEvent({required this.id});
  final String id;
  @override
  List<Object> get props => [];
}
