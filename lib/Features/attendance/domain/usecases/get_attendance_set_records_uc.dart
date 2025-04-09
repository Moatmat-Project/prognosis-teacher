import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

class GetAttendanceSetRecordsUC {
  final AttendanceRepository repository;

  GetAttendanceSetRecordsUC({required this.repository});
  Future<Either<Failure, List<AttendanceRecord>>> call(int params, {bool isOffline = false}) async {
    return await repository.getAttendanceSetRecords(setId: params, isOffline: isOffline);
  }
}
