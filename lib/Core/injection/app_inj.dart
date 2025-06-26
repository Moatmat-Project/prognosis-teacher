import 'package:get_it/get_it.dart';
import 'package:moatmat_teacher/Core/injection/banks_inj.dart';
import 'package:moatmat_teacher/Core/injection/buckets_inj.dart';
import 'package:moatmat_teacher/Core/injection/cash_inj.dart';
import 'package:moatmat_teacher/Core/injection/controllers_inj.dart';
import 'package:moatmat_teacher/Core/injection/groups_inj.dart';
import 'package:moatmat_teacher/Core/injection/notifications_inj.dart';
import 'package:moatmat_teacher/Core/injection/outer_tests_inj.dart';
import 'package:moatmat_teacher/Core/injection/purchases_inj.dart';
import 'package:moatmat_teacher/Core/injection/reports_inj.dart';
import 'package:moatmat_teacher/Core/injection/tests_inj.dart';
import 'package:moatmat_teacher/Core/injection/update_inj.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendance_inj.dart';
import 'auth_inj.dart';
import 'notifications2_inj.dart';
import 'requests_inj.dart';
import 'scanner_inj.dart';
import 'students_inj.dart';

var locator = GetIt.instance;
initGetIt() async {
  //
  var sp = await SharedPreferences.getInstance();
  locator.registerSingleton(sp);
  //
  injectAuth();
  //
  injectOuterTests();
  //
  await injectNotifications();
  //
  injectTests();
  //
  injectBanks();
  //
  injectBuckets();
  //
  injectReports();
  //
  purchasesInjector();
  //
  injectRequests();
  //
  injectStudents();
  //
  injectGroups();
  //
  injectNotifications2();
  //
  injectScanner();
  //
  injectUpdate();
  //
  injectCache();
  //
  injectAttendance();
  //
  injectControllers();
}
