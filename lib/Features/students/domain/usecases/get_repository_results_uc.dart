import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

import '../../../banks/domain/entities/bank.dart';
import '../entities/result.dart';
import '../repository/students_repo.dart';

class GetRepositoryResultsUC {
  final StudentsRepository repository;

  GetRepositoryResultsUC({required this.repository});

  Future<Either<Exception, List<Result>>> call({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) {
    return repository.getRepositoryResults(
      test: test,
      outerTest: outerTest,
      bank: bank,
      update: update,
    );
  }
}
