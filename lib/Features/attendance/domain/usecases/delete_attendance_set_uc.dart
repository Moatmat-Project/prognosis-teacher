import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class DeleteAttendanceSetUsecase {
  final AttendanceRepository repository;

  DeleteAttendanceSetUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required int id, required bool isOffline}) {
    return repository.deleteAttendanceSet(id: id, isOffline: isOffline);
  }
}
