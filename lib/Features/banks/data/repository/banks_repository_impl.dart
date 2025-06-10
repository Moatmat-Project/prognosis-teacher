import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/data/datasources/banks_remote_ds.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';

class BanksRepositoryImpl implements BanksRepository {
  final BanksRemoteDS dataSource;

  BanksRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Exception, Stream>> uploadBank({required Bank bank}) async {
    try {
      return right(dataSource.uploadBank(bank: bank));
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteBank({required int bankId}) async {
    try {
      await dataSource.deleteBank(bankId: bankId);
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Bank?>> getBankById({
    required int bankId,
    required bool update,
  }) async {
    try {
      var res = await dataSource.getBankById(bankId: bankId, update: update);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Bank>>> getMybBanks({
    required bool update,
  }) async {
    try {
      var res = await dataSource.getMyBanks(update: update);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Stream>> updateBank({required Bank bank}) async {
    try {
      return right(dataSource.updateBank(bank: bank));
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Bank>>> getBanksByIds(
      {required List<int> ids, required bool update}) async {
    try {
      var res = await dataSource.getBanksByIds(ids: ids, update: update);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
