import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

import '../entities/test/test.dart';

class GetTestsByIdsUC {
  final TestsRepository repository;

  GetTestsByIdsUC({required this.repository});

  Future<Either<Exception, List<Test>>> call({
    required List<int> ids,
    required bool update,
  }) async {
    return await repository.getTestsByIds(ids: ids, update: update);
  }
}
