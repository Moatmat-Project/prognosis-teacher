import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

import '../entities/test/test.dart';

class GetTestByIdUC {
  final TestsRepository repository;

  GetTestByIdUC({required this.repository});

  Future<Either<Exception, Test?>> call(
      {required int testId, required bool update}) async {
    return await repository.getTestById(testId: testId, update: update);
  }
}
