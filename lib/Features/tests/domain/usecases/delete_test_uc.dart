import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';


class DeleteTestsUC {
  final TestsRepository repository;

  DeleteTestsUC({required this.repository});

  Future<Either<Exception, Unit>> call({required int testId}) async {
    return await repository.deleteTest(testId: testId);
  }
}
