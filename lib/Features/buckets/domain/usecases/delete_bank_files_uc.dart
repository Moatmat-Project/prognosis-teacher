import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

import '../repository/buckets_repo.dart';

class DeleteBankFilesUC {
  final BucketsRepository repository;

  DeleteBankFilesUC({required this.repository});

  Future<Either<Exception, Unit>> call({
    required Bank oldBank,
    required Bank newBank,
  }) async {
    return await repository.deleteBanksFiles(
      oldBank: oldBank,
      newBank: newBank,
    );
  }
}
