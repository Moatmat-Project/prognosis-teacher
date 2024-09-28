import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/purchase/domain/repository/purchases_rep.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

import '../entities/purchase_item.dart';

class TestPurchasesUC {
  final PurchasesRepository repository;

  TestPurchasesUC({required this.repository});

  Future<Either<Exception, List<PurchaseItem>>> call({required Test test}) {
    return repository.testPurchases(test: test);
  }
}
