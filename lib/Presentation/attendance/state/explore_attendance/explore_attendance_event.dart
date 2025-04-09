part of 'explore_attendance_bloc.dart';

final class ExploreAttendanceEvent extends Equatable {
  const ExploreAttendanceEvent();

  @override
  List<Object> get props => [];
}

final class SyncAttendanceEvent extends ExploreAttendanceEvent {
  const SyncAttendanceEvent();

  @override
  List<Object> get props => [];
}

final class LoadAttendanceEvent extends ExploreAttendanceEvent {
  const LoadAttendanceEvent({this.isOffline = false});
  final bool isOffline;
  @override
  List<Object> get props => [];
}

final class DeleteAttendanceEvent extends ExploreAttendanceEvent {
  const DeleteAttendanceEvent(this.id, {this.isOffline = false});
  final int id;
  final bool isOffline;
  @override
  List<Object> get props => [];
}

final class CreateAttendanceEvent extends ExploreAttendanceEvent {
  const CreateAttendanceEvent(this.set, {this.isOffline = false});
  final AttendanceSet set;
  final bool isOffline;
  @override
  List<Object> get props => [];
}

final class UpdateAttendanceEvent extends ExploreAttendanceEvent {
  const UpdateAttendanceEvent(this.set, {this.isOffline = false});
  final AttendanceSet set;
  final bool isOffline;
  @override
  List<Object> get props => [];
}
