import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/repository/banks_repository.dart';

class UploadBankUC {
  final BanksRepository repository;

  UploadBankUC({required this.repository});

  Future<Either<Exception, Stream>> call({required Bank bank}) async {
    return await repository.uploadBank(bank: bank);
  }
}
