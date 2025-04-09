import 'package:get_it/get_it.dart';
import 'package:moatmat_teacher/Features/attendance/data/datasources/attendance_local_ds.dart';
import 'package:moatmat_teacher/Features/attendance/data/datasources/attendance_remote_ds.dart';
import 'package:moatmat_teacher/Features/attendance/data/repository/attendance_repository_implements.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/create_attendance_set_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/delete_attendance_set_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_set_records_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_sets_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/update_attendance_set_uc.dart';

import '../../Features/attendance/domain/usecases/get_student_records_uc.dart';
import '../../Features/attendance/domain/usecases/set_attendance_set_records_uc.dart';
import '../../Features/attendance/domain/usecases/sync_attendance_uc.dart';
import 'app_inj.dart';

Future<void> injectAttendance() async {
  //
  injectDS();
  injectRepo();
  injectUC();
}

injectDS() {
  //
  locator.registerLazySingleton<AttendanceRemoteDS>(
    () => AttendanceRemoteDSImpl(client: locator()),
  );
  //
  locator.registerLazySingleton<AttendanceLocalDS>(
    () => AttendanceLocalDSImpl(prefs: locator()),
  );
}

injectRepo() {
  locator.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(remoteDS: locator(), localDS: locator()),
  );
}

injectUC() {
  locator.registerLazySingleton<CreateAttendanceSetUsecase>(
    () => CreateAttendanceSetUsecase(repository: locator()),
  );
  locator.registerLazySingleton<GetStudentRecordsUC>(
    () => GetStudentRecordsUC(repository: locator()),
  );
  locator.registerLazySingleton<SyncAttendanceUC>(
    () => SyncAttendanceUC(repository: locator()),
  );
  //
  locator.registerLazySingleton<DeleteAttendanceSetUsecase>(
    () => DeleteAttendanceSetUsecase(repository: locator()),
  );
  //
  locator.registerLazySingleton<GetAttendanceSetsUsecase>(
    () => GetAttendanceSetsUsecase(repository: locator()),
  );
  //
  locator.registerLazySingleton<UpdateAttendanceSetUsecase>(
    () => UpdateAttendanceSetUsecase(repository: locator()),
  );
  //
  locator.registerLazySingleton<GetAttendanceSetRecordsUC>(
    () => GetAttendanceSetRecordsUC(repository: locator()),
  );
  //
  locator.registerLazySingleton<SetAttendanceSetRecordsUC>(
    () => SetAttendanceSetRecordsUC(repository: locator()),
  );
}
