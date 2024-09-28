import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

import '../repository/buckets_repo.dart';

class DeleteTestFilesUC {
  final BucketsRepository repository;

  DeleteTestFilesUC({required this.repository});

  Future<Either<Exception, Unit>> call({
    required Test oldTest,
    required Test newTest,
  }) async {
    return await repository.deleteTestFiles(
      oldTest: oldTest,
      newTest: newTest,
    );
  }
}
