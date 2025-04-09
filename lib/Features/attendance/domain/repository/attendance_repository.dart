import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';

import '../entities/attendance_set.dart';

abstract class AttendanceRepository {
  //
  Future<Either<Failure, List<AttendanceSet>>> getAttendanceSets({bool isOffline = false});
  //
  Future<Either<Failure, int?>> createAttendanceSet({required AttendanceSet set, bool isOffline = false});
  //
  Future<Either<Failure, Unit>> setAttendanceSetRecords({
    required List<AttendanceRecord> attendanceSetRecord,
    required int setId,
    bool isOffline = false,
  });
  //
  Future<Either<Failure, Unit>> updateAttendanceSet({required AttendanceSet set, bool isOffline = false});
  //
  Future<Either<Failure, Unit>> deleteAttendanceSet({required int id, bool isOffline = false});
  //
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceSetRecords({required int setId, bool isOffline = false});
  //
  Future<Either<Failure, List<AttendanceRecord>>> getStudentRecords({required String studentId});
  //
  Future<Either<Failure, Unit>> syncAttendance();
  //
}
