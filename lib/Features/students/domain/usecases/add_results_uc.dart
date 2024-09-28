import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/students/domain/repository/students_repo.dart';

import '../entities/result.dart';

class AddResultsUC {
  final StudentsRepository repository;

  AddResultsUC({required this.repository});

  Future<Either<Exception, Unit>> call({
    required List<Result> results,
  }) {
    return repository.addResults(
      results: results,
    );
  }
}
