part of 'set_up_attendance_bloc.dart';

final class SetUpAttendanceEvent extends Equatable {
  const SetUpAttendanceEvent();

  @override
  List<Object> get props => [];
}

final class LoadRecordsEvent extends SetUpAttendanceEvent {
  const LoadRecordsEvent(this.set, {this.isOffline = false});
  final bool isOffline;
  final AttendanceSet set;
  @override
  List<Object> get props => [];
}

final class SaveChangesEvent extends SetUpAttendanceEvent {
  const SaveChangesEvent({this.isOffline = false});
  final bool isOffline;
  @override
  List<Object> get props => [];
}

final class ChangeRangeFiltersEvent extends SetUpAttendanceEvent {
  const ChangeRangeFiltersEvent({this.starting, this.ending});
  final DateTime? starting, ending;
  @override
  List<Object> get props => [];
}

final class AddRecordEvent extends SetUpAttendanceEvent {
  const AddRecordEvent(this.record);
  final AttendanceRecord record;
  @override
  List<Object> get props => [];
}

final class DeleteRecordEvent extends SetUpAttendanceEvent {
  const DeleteRecordEvent(this.record);

  final AttendanceRecord record;
  @override
  List<Object> get props => [];
}
