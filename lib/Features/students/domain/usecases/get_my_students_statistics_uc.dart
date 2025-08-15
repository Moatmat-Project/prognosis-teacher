import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import '../../data/responses/get_my_students_statistics_response.dart';
import '../entities/user_data.dart';
import '../repository/students_repo.dart';

class GetMyStudentsResultsUc {
  final StudentsRepository repository;

  GetMyStudentsResultsUc({required this.repository});

  Future<Either<Exception, List<Result>>> call({
    required List<String> studentsIds,
    required List<String> testsIds,
    required List<String> setsIds,
  }) {
    return repository.getMyStudentsResults(studentsIds: studentsIds, testsIds: testsIds, setsIds: setsIds);
  }
}
