part of 'explore_student_attendance_bloc.dart';

final class ExploreStudentAttendanceState extends Equatable {
  const ExploreStudentAttendanceState({
    this.message,
    required this.isLoading,
    required this.sets,
    required this.records,
    required this.recordsSetsIds,
    required this.attendedCount,
    required this.notAttendedCount,
  });
  final bool isLoading;
  final String? message;
  final List<AttendanceSet> sets;
  final List<AttendanceRecord> records;
  final List<String> recordsSetsIds;
  final int attendedCount, notAttendedCount;

  factory ExploreStudentAttendanceState.loading() {
    return ExploreStudentAttendanceState(
      sets: [],
      records: [],
      recordsSetsIds: [],
      isLoading: true,
      message: null,
      attendedCount: 0,
      notAttendedCount: 0,
    );
  }
  ExploreStudentAttendanceState toInitial({
    String? message,
    bool? isLoading,
    List<AttendanceSet> sets = const [],
    List<AttendanceRecord> records = const [],
    List<String> recordsSetsIds = const [],
    int attendedCount = 0,
    int notAttendedCount = 0,
  }) {
    return ExploreStudentAttendanceState(
      sets: sets,
      records: records,
      recordsSetsIds: recordsSetsIds,
      isLoading: false,
      message: message,
      attendedCount: attendedCount,
      notAttendedCount: notAttendedCount,
    );
  }

  ExploreStudentAttendanceState toLoading() {
    return ExploreStudentAttendanceState(
      sets: sets,
      records: records,
      recordsSetsIds: recordsSetsIds,
      isLoading: true,
      message: message,
      attendedCount: attendedCount,
      notAttendedCount: notAttendedCount,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        message,
        sets,
        records,
        recordsSetsIds,
        attendedCount,
        notAttendedCount,
      ];
}
