import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';

class DeleteBankUC {
  final BanksRepository repository;

  DeleteBankUC({required this.repository});

  Future<Either<Exception, Unit>> call({required int bankId}) async {
    return await repository.deleteBank(bankId: bankId);
  }
}
