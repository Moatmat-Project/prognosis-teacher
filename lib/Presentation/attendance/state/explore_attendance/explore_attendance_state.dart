part of 'explore_attendance_bloc.dart';

final class ExploreAttendanceState extends Equatable {
  final bool isLoading, isOffline;
  final String? error;
  final List<AttendanceSet> attendanceSets;

  const ExploreAttendanceState({
    required this.isOffline,
    required this.isLoading,
    required this.error,
    required this.attendanceSets,
  });

  factory ExploreAttendanceState.loading() {
    return const ExploreAttendanceState(
      isLoading: true,
      isOffline: false,
      error: null,
      attendanceSets: [],
    );
  }

  factory ExploreAttendanceState.error(String error) {
    return ExploreAttendanceState(
      isLoading: false,
      isOffline: false,
      error: error,
      attendanceSets: [],
    );
  }

  factory ExploreAttendanceState.initial({
    bool? isOffline,
    required List<AttendanceSet> attendanceSets,
  }) {
    return ExploreAttendanceState(
      isLoading: false,
      isOffline: isOffline ?? false,
      error: null,
      attendanceSets: attendanceSets,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        attendanceSets,
      ];
}
