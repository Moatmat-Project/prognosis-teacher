import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class CreateAttendanceSetUsecase {
  final AttendanceRepository repository;

  CreateAttendanceSetUsecase({required this.repository});

  Future<Either<Failure, int?>> call({required AttendanceSet set, bool isOffline = false}) {
    return repository.createAttendanceSet(set: set, isOffline: isOffline);
  }
}
