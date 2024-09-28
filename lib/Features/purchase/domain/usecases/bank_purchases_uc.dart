import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/purchase/domain/repository/purchases_rep.dart';

import '../entities/purchase_item.dart';

class BankPurchasesUC {
  final PurchasesRepository repository;

  BankPurchasesUC({required this.repository});

  Future<Either<Exception, List<PurchaseItem>>> call({required Bank bank}) {
    return repository.bankPurchases(bank: bank);
  }
}
