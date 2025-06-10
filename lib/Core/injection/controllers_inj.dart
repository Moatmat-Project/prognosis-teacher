import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/create_attendance_set_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/delete_attendance_set_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_set_records_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_sets_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_student_records_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/sync_attendance_uc.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/update_attendance_set_uc.dart';
import 'package:moatmat_teacher/Features/groups/domain/usecases/set_group_tests_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_tests_by_ids_uc.dart';
import 'package:moatmat_teacher/Presentation/attendance/state/explore_attendance/explore_attendance_bloc.dart';
import 'package:moatmat_teacher/Presentation/students/state/blocs/explore_student_attendance_bloc.dart';
import '../../Features/attendance/domain/usecases/set_attendance_set_records_uc.dart';
import '../../Features/groups/domain/usecases/get_teacher_groups_uc.dart';
import '../../Features/students/domain/usecases/get_my_students_statistics_uc.dart';
import '../../Presentation/attendance/state/explore_group_attendance/explore_group_attendance_bloc.dart';
import '../../Presentation/attendance/state/set_up_attendance/set_up_attendance_bloc.dart';
import '../../Presentation/auth/state/switch_accounts/switch_accounts_bloc.dart';
import '../../Presentation/groups/state/manage_group_tests/manage_group_tests_bloc.dart';
import '../../Presentation/statistics/state/bloc/export_students_statistics_bloc.dart';

injectControllers() {
  locator.registerSingleton(
    ExploreAttendanceBloc(
      getAttendanceSetsUsecase: locator<GetAttendanceSetsUsecase>(),
      createAttendanceSetUsecase: locator<CreateAttendanceSetUsecase>(),
      deleteAttendanceSetUsecase: locator<DeleteAttendanceSetUsecase>(),
      updateAttendanceSetUsecase: locator<UpdateAttendanceSetUsecase>(),
      syncAttendanceUC: locator<SyncAttendanceUC>(),
    )..add(SyncAttendanceEvent()),
  );
  locator.registerSingleton(
    SetUpAttendanceBloc(
      locator<GetAttendanceSetRecordsUC>(),
      locator<SetAttendanceSetRecordsUC>(),
    ),
  );
  locator.registerSingleton(
    ManageGroupTestsBloc(
      locator<GetTestsByIdsUC>(),
      locator<SetGroupTestsUC>(),
    ),
  );
  locator.registerFactory(
    () => SwitchAccountsBloc(),
  );
  locator.registerSingleton(
    ExploreStudentAttendanceBloc(
      locator<GetAttendanceSetsUsecase>(),
      locator<GetStudentRecordsUC>(),
    ),
  );
  locator.registerSingleton(
    ExportStudentsStatisticsBloc(
      locator<GetMyStudentsStatisticsUc>(),
      locator<GetAttendanceSetsUsecase>(),
    ),
  );
  locator.registerSingleton(
    ExploreGroupAttendanceBloc(
      locator<GetTeacherGroupsUc>(),
    ),
  );
}
