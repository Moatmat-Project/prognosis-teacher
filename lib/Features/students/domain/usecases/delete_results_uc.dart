import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/students/domain/repository/students_repo.dart';

class DeleteResultsUC {
  final StudentsRepository repository;

  DeleteResultsUC({required this.repository});

  Future<Either<Exception, Unit>> call({
    List<int>? results,
    int? testId,
    int? outerTestId,
    int? bankId,
  }) {
    return repository.deleteRepositoryResults(
      results: results,
      testId: testId,
      outerTestId: outerTestId,
      bankId: bankId,
    );
  }
}
