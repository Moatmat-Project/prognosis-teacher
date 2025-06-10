import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

import '../entities/test/test.dart';

class UpdateTestUC {
  final TestsRepository repository;

  UpdateTestUC({required this.repository});

  Future<Either<Exception, Stream>> call({required Test test}) async {
    return  repository.updateTest(test: test);
  }
}
