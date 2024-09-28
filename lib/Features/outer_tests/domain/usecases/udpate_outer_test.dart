import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/repository/outer_tests_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/outer_test.dart';

class UpdateOuterTestUseCase {
  final OuterTestsRepository repository;

  UpdateOuterTestUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required OuterTest test}) async {
    return repository.updateOuterTest(test: test);
  }
}
