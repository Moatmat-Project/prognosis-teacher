import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';

class GetBankByIdUC {
  final BanksRepository repository;

  GetBankByIdUC({required this.repository});

  Future<Either<Exception, Bank?>> call({required int bankId,required bool update,}) async {
    return await repository.getBankById(bankId: bankId,update: update);
  }
}
