import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';

class GetBanksByIdsUC {
  final BanksRepository repository;

  GetBanksByIdsUC({required this.repository});

  Future<Either<Exception, List<Bank>>> call({
    required List<int> ids,
    required bool update,
  }) async {
    return await repository.getBanksByIds(
      ids: ids,
      update: update,
    );
  }
}
