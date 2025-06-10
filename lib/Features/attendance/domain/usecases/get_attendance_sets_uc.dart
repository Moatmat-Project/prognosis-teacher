import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class GetAttendanceSetsUsecase {
  final AttendanceRepository repository;

  GetAttendanceSetsUsecase({required this.repository});

  Future<Either<Failure, List<AttendanceSet>>> call({bool isOffline = false}) {
    return repository.getAttendanceSets(isOffline: isOffline);
  }
}
