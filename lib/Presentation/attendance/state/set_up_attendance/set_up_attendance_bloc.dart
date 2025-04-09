import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Features/attendance/data/models/attendance_record_model.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_set_records_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/set_attendance_set_records_uc.dart';
part 'set_up_attendance_event.dart';
part 'set_up_attendance_state.dart';

class SetUpAttendanceBloc extends Bloc<SetUpAttendanceEvent, SetUpAttendanceState> {
  final GetAttendanceSetRecordsUC _getAttendanceSetRecordsUC;
  final SetAttendanceSetRecordsUC _setAttendanceSetRecordsUC;
  SetUpAttendanceBloc(this._getAttendanceSetRecordsUC, this._setAttendanceSetRecordsUC) : super(SetUpAttendanceState.loading()) {
    on<LoadRecordsEvent>(onLoadRecordsEvent);
    on<SaveChangesEvent>(onSaveChangesEvent);
    on<ChangeRangeFiltersEvent>(onChangeRangeFiltersEvent);
    on<AddRecordEvent>(onAddRecordEvent);
    on<DeleteRecordEvent>(onDeleteRecordEvent);
  }
  onLoadRecordsEvent(LoadRecordsEvent event, Emitter<SetUpAttendanceState> emit) async {
    emit(state.toLoading());
    final response = await _getAttendanceSetRecordsUC(event.set.id, isOffline: event.isOffline);
    response.fold(
      (l) {
        emit(state.toFailure(l.text));
      },
      (r) {
        r.sort((a, b) => a.date.compareTo(b.date));
        final DateTime? starting = r.firstOrNull?.date;
        final DateTime? ending = r.lastOrNull?.date;
        emit(state.toInitial(records: r, starting: starting, ending: ending, set: event.set));
      },
    );
  }

  onAddRecordEvent(AddRecordEvent event, Emitter<SetUpAttendanceState> emit) async {
    if (state.records.every((e) => e.studentId != event.record.studentId)) {
      final newRecords = List<AttendanceRecord>.from(state.records)..add(AttendanceRecordModel.fromClass(event.record));
      newRecords.sort((a, b) => a.date.compareTo(b.date));
      final DateTime? starting = newRecords.firstOrNull?.date;
      final DateTime? ending = newRecords.lastOrNull?.date;
      emit(state.toInitial(records: newRecords, starting: starting, ending: ending, canSave: true));
    }
  }

  onDeleteRecordEvent(DeleteRecordEvent event, Emitter<SetUpAttendanceState> emit) async {
    final newRecords = List<AttendanceRecord>.from(state.records);
    if (newRecords.isNotEmpty) {
      newRecords.remove(event.record);
    }
    emit(state.toInitial(records: newRecords, canSave: true));
  }

  onChangeRangeFiltersEvent(ChangeRangeFiltersEvent event, Emitter<SetUpAttendanceState> emit) async {
    emit(state.toInitial(starting: event.starting, ending: event.ending));
  }

  onSaveChangesEvent(SaveChangesEvent event, Emitter<SetUpAttendanceState> emit) async {
    emit(state.toSaving());
    final response = await _setAttendanceSetRecordsUC(
      attendanceSetRecord: state.records,
      setId: state.set.id,
      isOffline: event.isOffline,
    );
    response.fold(
      (l) {
        emit(state.toFailure(l.text));
      },
      (r) {
        emit(state.toInitial(records: state.records, message: "تم حفظ التغييرات بنجاح"));
      },
    );
  }
}
