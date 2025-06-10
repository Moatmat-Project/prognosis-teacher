import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class SetAttendanceSetRecordsUC {
  final AttendanceRepository repository;

  SetAttendanceSetRecordsUC({required this.repository});

  Future<Either<Failure, Unit>> call({
    required List<AttendanceRecord> attendanceSetRecord,
    required int setId,
    bool isOffline = false,
  }) async {
    return await repository.setAttendanceSetRecords(
      attendanceSetRecord: attendanceSetRecord,
      setId: setId,
      isOffline: isOffline,
    );
  }
}
