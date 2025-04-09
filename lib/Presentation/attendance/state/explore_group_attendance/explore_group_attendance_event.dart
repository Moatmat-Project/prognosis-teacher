part of 'explore_group_attendance_bloc.dart';

sealed class ExploreGroupAttendanceEvent extends Equatable {
  const ExploreGroupAttendanceEvent();

  @override
  List<Object> get props => [];
}

final class InitializeAttendanceEvent extends ExploreGroupAttendanceEvent {
  const InitializeAttendanceEvent(this.set, this.records);
  final AttendanceSet set;
  final List<AttendanceRecord> records;
  @override
  List<Object> get props => [];
}

final class PickGroupEvent extends ExploreGroupAttendanceEvent {
  const PickGroupEvent(this.group);
  final Group group;
  @override
  List<Object> get props => [];
}
