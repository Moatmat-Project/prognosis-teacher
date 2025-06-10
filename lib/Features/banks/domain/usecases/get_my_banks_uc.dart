import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';

class GetMyBanksUC {
  final BanksRepository repository;

  GetMyBanksUC({required this.repository});

  Future<Either<Exception, List<Bank>>> call({
     bool update=false,
  }) async {
    return await repository.getMybBanks(update: update);
  }
}
