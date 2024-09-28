import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/repository/outer_tests_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/outer_test.dart';

class GetOuterTestsUseCase {
  final OuterTestsRepository repository;

  GetOuterTestsUseCase({required this.repository});

  Future<Either<Failure, List<OuterTest>>> call() async {
    return repository.getOuterTests();
  }
}
