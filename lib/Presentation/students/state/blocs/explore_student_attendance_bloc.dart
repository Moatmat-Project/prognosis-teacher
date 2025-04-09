import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_sets_uc.dart';

import '../../../../Features/attendance/domain/usecases/get_student_records_uc.dart';

part 'explore_student_attendance_event.dart';
part 'explore_student_attendance_state.dart';

class ExploreStudentAttendanceBloc extends Bloc<ExploreStudentAttendanceEvent, ExploreStudentAttendanceState> {
  final GetAttendanceSetsUsecase _getAttendanceSetsUsecase;
  final GetStudentRecordsUC _getStudentRecordsUC;
  ExploreStudentAttendanceBloc(this._getAttendanceSetsUsecase, this._getStudentRecordsUC) : super(ExploreStudentAttendanceState.loading()) {
    on<LoadStudentAttendanceEvent>(onLoadStudentAttendanceEvent);
  }
  onLoadStudentAttendanceEvent(LoadStudentAttendanceEvent event, Emitter<ExploreStudentAttendanceState> emit) async {
    emit(ExploreStudentAttendanceState.loading());
    final attendanceSetsResponse = await _getAttendanceSetsUsecase.call();
    await attendanceSetsResponse.fold(
      (l1) async {
        emit(state.toInitial(message: "حصل خطا ما"));
      },
      (attendanceSets) async {
        final studentRecordsResponse = await _getStudentRecordsUC.call(event.id);
        await studentRecordsResponse.fold(
          (l2) async {
            emit(state.toInitial(message: "حصل خطا ما"));
          },
          (studentRecords) async {
            int attendedCount = 0, notAttendedCount = 0;
            for (var set in attendanceSets) {
              if (studentRecords.any((e) => e.attendanceSetId == set.id.toString())) {
                attendedCount++;
              } else {
                notAttendedCount++;
              }
            }

            emit(
              state.toInitial(
                sets: attendanceSets,
                records: studentRecords,
                recordsSetsIds: studentRecords.map((e) => e.attendanceSetId).toSet().toList(),
                attendedCount: attendedCount,
                notAttendedCount: notAttendedCount,
              ),
            );
          },
        );
      },
    );
  }
}
