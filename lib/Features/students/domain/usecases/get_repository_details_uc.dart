import 'package:moatmat_teacher/Features/students/domain/entities/test_details.dart';
import 'package:moatmat_teacher/Features/students/domain/repository/students_repo.dart';

import '../../../banks/domain/entities/bank.dart';
import '../../../outer_tests/domain/entities/outer_test.dart';
import '../../../tests/domain/entities/test/test.dart';
import '../entities/result.dart';

class GetRepositoryDetailsUC {
  final StudentsRepository repository;

  GetRepositoryDetailsUC({required this.repository});

  RepositoryDetails call({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required List<Result> results,
    required bool update,
  }) {
    return repository.getRepositoryDetails(
      test: test,
      outerTest: outerTest,
      bank: bank,
      results: results,
      update: update,
    );
  }
}
