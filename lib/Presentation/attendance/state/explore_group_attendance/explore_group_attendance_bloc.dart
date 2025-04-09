import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/auth/domain/entites/teacher_data.dart';
import '../../../../Features/groups/domain/usecases/get_teacher_groups_uc.dart';

part 'explore_group_attendance_event.dart';
part 'explore_group_attendance_state.dart';

class ExploreGroupAttendanceBloc extends Bloc<ExploreGroupAttendanceEvent, ExploreGroupAttendanceState> {
  final GetTeacherGroupsUc _getTeacherGroupsUc;
  ExploreGroupAttendanceBloc(this._getTeacherGroupsUc) : super(ExploreGroupAttendanceLoading()) {
    on<InitializeAttendanceEvent>(_onInitializeAttendanceEvent);
    on<PickGroupEvent>(_onPickGroupEvent);
  }

  ///
  _onInitializeAttendanceEvent(InitializeAttendanceEvent event, Emitter<ExploreGroupAttendanceState> emit) async {
    //
    emit(ExploreGroupAttendanceLoading());
    //
    var groupRes = await _getTeacherGroupsUc.call(
      teacherEmail: locator<TeacherData>().email,
    );
    groupRes.fold(
      (l) {
        emit(ExploreGroupAttendancePickGroup(
          students: [],
          groups: [],
          set: event.set,
          records: event.records,
          message: l.toString(),
        ));
      },
      (r) {
        emit(ExploreGroupAttendancePickGroup(
          students: [],
          groups: r,
          set: event.set,
          records: event.records,
        ));
      },
    );
  }

  ///
  _onPickGroupEvent(PickGroupEvent event, Emitter<ExploreGroupAttendanceState> emit) async {
    //
    emit(ExploreGroupAttendanceLoading(state: state));

    int attendedCount = 0, absentCount = 0;
    final students = event.group.items.map((e) => e.userData).toList();

    // 
    students.sort((a, b) {
      bool aAttended = state.records.any((e) => e.studentId == a.id);
      bool bAttended = state.records.any((e) => e.studentId == b.id);
      return (bAttended ? 1 : 0).compareTo(aAttended ? 1 : 0); 
    });

    for (var student in students) {
      if (state.records.any((e) => e.studentId == student.id)) {
        attendedCount++;
      } else {
        absentCount++;
      }
    }

    emit(
      ExploreGroupAttendanceDetails(
        students: students,
        set: state.set,
        records: state.records,
        group: event.group,
        absentCount: absentCount,
        attendedCount: attendedCount,
      ),
    );
  }
}
