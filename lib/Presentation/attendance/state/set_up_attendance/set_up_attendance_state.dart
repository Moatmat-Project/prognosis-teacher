part of 'set_up_attendance_bloc.dart';

final class SetUpAttendanceState extends Equatable {
  const SetUpAttendanceState({
    this.message,
    required this.records,
    required this.isLoading,
    required this.isSaving,
    required this.canSave,
    required this.starting,
    required this.ending,
    required this.set,
  });
  final String? message;
  final bool isLoading, isSaving, canSave;
  final DateTime? starting, ending;
  final AttendanceSet set;
  final List<AttendanceRecord> records;

  SetUpAttendanceState toLoading() {
    return SetUpAttendanceState(
      message: message,
      records: records,
      isLoading: true,
      isSaving: false,
      canSave: false,
      starting: starting,
      ending: ending,
      set: set,
    );
  }

  SetUpAttendanceState toSaving() {
    return SetUpAttendanceState(
      message: message,
      records: records,
      isLoading: false,
      isSaving: true,
      canSave: false,
      starting: starting,
      ending: ending,
      set: set,
    );
  }

  SetUpAttendanceState toInitial({
    AttendanceSet? set,
    bool? canSave,
    List<AttendanceRecord>? records,
    String? message,
    DateTime? starting,
    DateTime? ending,
  }) {
    return SetUpAttendanceState(
      message: message,
      records: records ?? this.records,
      isLoading: false,
      isSaving: false,
      canSave: canSave ?? false,
      starting: starting ?? this.starting,
      ending: ending ?? this.ending,
      set: set ?? this.set,
    );
  }

  SetUpAttendanceState toFailure(String message) {
    return SetUpAttendanceState(
      message: message,
      records: records,
      isLoading: false,
      isSaving: false,
      canSave: false,
      starting: starting,
      ending: ending,
      set: set,
    );
  }

  factory SetUpAttendanceState.loading() {
    return SetUpAttendanceState(
      message: null,
      records: [],
      isLoading: true,
      isSaving: false,
      canSave: false,
      starting: DateTime.now(),
      ending: DateTime.now(),
      set: AttendanceSet.empty(),
    );
  }

  @override
  List<Object?> get props => [message, records, isLoading, isSaving, starting, ending, set, canSave];
}
