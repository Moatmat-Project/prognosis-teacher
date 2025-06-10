import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';

abstract class BanksRepository {
  Future<Either<Exception, Stream>> uploadBank({required Bank bank});

  //
  Future<Either<Exception, Stream>> updateBank({
    required Bank bank,
  });
  //
  Future<Either<Exception, Unit>> deleteBank({
    required int bankId,
  });
  //
  Future<Either<Exception, Bank?>> getBankById({
    required int bankId,
    required bool update,
  });
  //
  Future<Either<Exception, List<Bank>>> getBanksByIds({
    required List<int> ids,
    required bool update,
  });
  //
  Future<Either<Exception, List<Bank>>> getMybBanks({required bool update});
  //
  
}
