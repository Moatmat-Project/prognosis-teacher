import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/attendance/data/datasources/attendance_local_ds.dart';
import 'package:moatmat_teacher/Features/attendance/data/datasources/attendance_remote_ds.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDS remoteDS;
  final AttendanceLocalDS localDS;

  AttendanceRepositoryImpl({
    required this.remoteDS,
    required this.localDS,
  });

  @override
  Future<Either<Failure, int?>> createAttendanceSet({required AttendanceSet set, bool isOffline = false}) async {
    try {
      if (isOffline) {
        await localDS.createAttendanceSet(set: set);
        return right(set.id);
      }
      final response = await remoteDS.createAttendanceSet(set: set);
      return right(response);
    } catch (e) {
      return left(AnonFailure(text: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAttendanceSet({required int id, bool isOffline = false}) async {
    try {
      if (isOffline) {
        await localDS.deleteAttendanceSet(id: id);
        return right(unit);
      }
      await remoteDS.deleteAttendanceSet(id: id);
      return right(unit);
    } catch (e) {
      return left(AnonFailure(text: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceSet>>> getAttendanceSets({bool isOffline = false}) async {
    try {
      if (isOffline) {
        return right(await localDS.getAttendanceSets());
      }
      final res = await remoteDS.getAttendanceSets();
      return right(res);
    } catch (e) {
      return left(AnonFailure(text: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAttendanceSet({required AttendanceSet set, bool isOffline = false}) async {
    try {
      if (isOffline) {
        await localDS.updateAttendanceSet(set: set);
        return right(unit);
      }
      await remoteDS.updateAttendanceSet(set: set);
      return right(unit);
    } catch (e) {
      return left(AnonFailure(text: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceSetRecords({required int setId, bool isOffline = false}) async {
    try {
      if (isOffline) {
        return right(await localDS.getAttendanceSetRecords(id: setId));
      }
      final res = await remoteDS.getAttendanceSetRecords(id: setId);
      return right(res);
    } catch (e) {
      return left(AnonFailure(text: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecord>>> getStudentRecords({required String studentId}) async {
    try {
      final res = await remoteDS.getStudentRecords(id: studentId);
      return right(res);
    } catch (e) {
      return left(AnonFailure(text: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setAttendanceSetRecords({required List<AttendanceRecord> attendanceSetRecord, required int setId, bool isOffline = false}) async {
    try {
      if (isOffline) {
        await localDS.setAttendanceSetRecords(attendanceSetRecord: attendanceSetRecord, setId: setId);
        return right(unit);
      }
      await remoteDS.setAttendanceSetRecords(attendanceSetRecord: attendanceSetRecord, setId: setId);
      return right(unit);
    } catch (e) {
      return left(AnonFailure(text: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> syncAttendance() async {
    try {
      List<AttendanceSet> sets = await localDS.getAttendanceSets();
      for (var set in sets) {
        try {
          await remoteDS.syncAttendanceSet(
            set: set,
            records: await localDS.getAttendanceSetRecords(id: set.id),
          );
          await localDS.deleteAttendanceSet(id: set.id);
        } on Exception {
          return left(AnonFailure());
        }
      }
      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }
}
