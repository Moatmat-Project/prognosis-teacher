import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class UpdateAttendanceSetUsecase {
  final AttendanceRepository repository;

  UpdateAttendanceSetUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required AttendanceSet set, required bool isOffline}) {
    return repository.updateAttendanceSet(set: set, isOffline: isOffline);
  }
}
