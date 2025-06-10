import 'package:dartz/dartz.dart';

import '../entities/result.dart';
import '../repository/students_repo.dart';

class GetStudentResultsUC {
  final StudentsRepository repository;

  GetStudentResultsUC({required this.repository});

  Future<Either<Exception, List<Result>>> call({
    required String id,
    required bool update,
  }) {
    return repository.getStudentResults(id: id, update: update);
  }
}
