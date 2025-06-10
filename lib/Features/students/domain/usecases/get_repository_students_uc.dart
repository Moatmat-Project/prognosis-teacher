import 'package:dartz/dartz.dart';

import '../../../banks/domain/entities/bank.dart';
import '../../../outer_tests/domain/entities/outer_test.dart';
import '../../../tests/domain/entities/test/test.dart';
import '../entities/user_data.dart';
import '../repository/students_repo.dart';

class GetRepositoryStudentsUC {
  final StudentsRepository repository;

  GetRepositoryStudentsUC({required this.repository});

  Future<Either<Exception, List<UserData>>> call({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) {
    return repository.getRepositoryStudents(
      test: test,
      outerTest: outerTest,
      bank: bank,
      update: update,
    );
  }
}
