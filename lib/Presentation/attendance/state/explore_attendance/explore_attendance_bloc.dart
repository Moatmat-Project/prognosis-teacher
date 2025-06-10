import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/sync_attendance_uc.dart';
import '../../../../Features/attendance/domain/usecases/create_attendance_set_uc.dart';
import '../../../../Features/attendance/domain/usecases/delete_attendance_set_uc.dart';
import '../../../../Features/attendance/domain/usecases/get_attendance_sets_uc.dart';
import '../../../../Features/attendance/domain/usecases/update_attendance_set_uc.dart';

part 'explore_attendance_event.dart';
part 'explore_attendance_state.dart';

class ExploreAttendanceBloc extends Bloc<ExploreAttendanceEvent, ExploreAttendanceState> {
  final GetAttendanceSetsUsecase _getAttendanceSetsUsecase;
  final CreateAttendanceSetUsecase _createAttendanceSetUsecase;
  final DeleteAttendanceSetUsecase _deleteAttendanceSetUsecase;
  final UpdateAttendanceSetUsecase _updateAttendanceSetUsecase;
  final SyncAttendanceUC _syncAttendanceUC;

  ExploreAttendanceBloc({
    required GetAttendanceSetsUsecase getAttendanceSetsUsecase,
    required CreateAttendanceSetUsecase createAttendanceSetUsecase,
    required DeleteAttendanceSetUsecase deleteAttendanceSetUsecase,
    required UpdateAttendanceSetUsecase updateAttendanceSetUsecase,
    required SyncAttendanceUC syncAttendanceUC,
  })  : _getAttendanceSetsUsecase = getAttendanceSetsUsecase,
        _createAttendanceSetUsecase = createAttendanceSetUsecase,
        _deleteAttendanceSetUsecase = deleteAttendanceSetUsecase,
        _updateAttendanceSetUsecase = updateAttendanceSetUsecase,
        _syncAttendanceUC = syncAttendanceUC,
        super(ExploreAttendanceState.loading()) {
    on<LoadAttendanceEvent>(_onLoadAttendanceEvent);
    on<CreateAttendanceEvent>(_onCreateAttendanceEvent);
    on<DeleteAttendanceEvent>(_onDeleteAttendanceEvent);
    on<UpdateAttendanceEvent>(_onUpdateAttendanceEvent);
    on<SyncAttendanceEvent>(_onSyncAttendanceEvent);
  }

  _onSyncAttendanceEvent(SyncAttendanceEvent event, Emitter<ExploreAttendanceState> emit) async {
    //
    emit(ExploreAttendanceState.loading());
    //
    final res = await _syncAttendanceUC.call();
    res.fold(
      (l) {},
      (r) {},
    );
  }

  _onLoadAttendanceEvent(LoadAttendanceEvent event, Emitter<ExploreAttendanceState> emit) async {
    //
    emit(ExploreAttendanceState.loading());
    //
    final res = await _getAttendanceSetsUsecase.call(isOffline: event.isOffline);
    res.fold(
      (l) => emit(ExploreAttendanceState.error(l.text)),
      (r) => emit(
        ExploreAttendanceState.initial(
          attendanceSets: r,
        ),
      ),
    );
  }

  _onCreateAttendanceEvent(CreateAttendanceEvent event, Emitter<ExploreAttendanceState> emit) async {
    //
    emit(ExploreAttendanceState.loading());
    //
    final res = await _createAttendanceSetUsecase.call(set: event.set, isOffline: event.isOffline);
    //
    res.fold(
      (l) => emit(ExploreAttendanceState.error(l.text)),
      (r) => add(LoadAttendanceEvent(isOffline: event.isOffline)),
    );
  }

  _onDeleteAttendanceEvent(DeleteAttendanceEvent event, Emitter<ExploreAttendanceState> emit) async {
    //
    emit(ExploreAttendanceState.loading());
    //
    final res = await _deleteAttendanceSetUsecase.call(id: event.id, isOffline: event.isOffline);
    //
    res.fold(
      (l) => emit(ExploreAttendanceState.error(l.text)),
      (r) => add(LoadAttendanceEvent(isOffline: event.isOffline)),
    );
  }

  _onUpdateAttendanceEvent(UpdateAttendanceEvent event, Emitter<ExploreAttendanceState> emit) async {
    //
    emit(ExploreAttendanceState.loading());
    //
    final res = await _updateAttendanceSetUsecase.call(set: event.set, isOffline: event.isOffline);
    res.fold(
      (l) => emit(ExploreAttendanceState.error(l.text)),
      (r) => add(LoadAttendanceEvent(isOffline: event.isOffline)),
    );
  }
}
