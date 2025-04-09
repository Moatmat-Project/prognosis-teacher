import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';
import '../../../../Core/errors/exceptions.dart';

class SyncAttendanceUC {
  final AttendanceRepository repository;

  SyncAttendanceUC({required this.repository});

  Future<Either<Failure, Unit>> call() {
    return repository.syncAttendance();
  }
}
