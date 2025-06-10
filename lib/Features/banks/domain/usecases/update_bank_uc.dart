import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';

class UpdateBankUC {
  final BanksRepository repository;

  UpdateBankUC({required this.repository});

  Future<Either<Exception, Stream>> call({required Bank bank}) async {
    return await repository.updateBank(bank: bank);
  }
}
