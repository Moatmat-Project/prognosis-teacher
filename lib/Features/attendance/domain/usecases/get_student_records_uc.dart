import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/repository/attendance_repository.dart';

class GetStudentRecordsUC {
  final AttendanceRepository repository;

  GetStudentRecordsUC({required this.repository});
  Future<Either<Failure, List<AttendanceRecord>>> call(String params) async {
    return await repository.getStudentRecords(studentId: params);
  }
}
