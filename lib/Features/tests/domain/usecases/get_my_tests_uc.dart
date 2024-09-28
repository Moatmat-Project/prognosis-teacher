import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

import '../entities/test/test.dart';

class GetMyTestsUC {
  final TestsRepository repository;

  GetMyTestsUC({required this.repository});

  Future<Either<Exception, List<Test>>> call({ bool update=false}) async {
    return await repository.getMyTests(update: update);
  }
}
