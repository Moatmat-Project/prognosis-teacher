part of 'explore_group_attendance_bloc.dart';

final class ExploreGroupAttendanceState extends Equatable {
  const ExploreGroupAttendanceState({
    required this.set,
    required this.records,
    required this.students,
    this.message,
  });
  final AttendanceSet set;
  final List<AttendanceRecord> records;
  final List<UserData> students;
  final String? message;
  @override
  List<Object?> get props => [
        set,
        records,
        students,
        message,
      ];
}

final class ExploreGroupAttendanceLoading extends ExploreGroupAttendanceState {
  ExploreGroupAttendanceLoading({
    ExploreGroupAttendanceState? state,
  }) : super(
          set: state?.set ?? AttendanceSet.empty(),
          records: state?.records ?? [],
          students: state?.students ?? [],
        );
}

final class ExploreGroupAttendancePickGroup extends ExploreGroupAttendanceState {
  final List<Group> groups;
  const ExploreGroupAttendancePickGroup({
    required super.students,
    required this.groups,
    required super.set,
    required super.records,
    super.message,
  });
}

final class ExploreGroupAttendanceDetails extends ExploreGroupAttendanceState {
  final int attendedCount, absentCount;
  final Group group;
  const ExploreGroupAttendanceDetails({
    required this.attendedCount,
    required this.absentCount,
    required super.students,
    required super.set,
    required super.records,
    required this.group,
    super.message,
  });
}
