

import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_teacher/Features/purchase/domain/repository/purchases_rep.dart';

class GetTestPurchasesByIdsUC {
  final PurchasesRepository repository;

  GetTestPurchasesByIdsUC({required this.repository});

  Future<Either<Exception, List<PurchaseItem>>> call({required List<int> testIds}) {
    return repository.getTestPurchasesByIds(testIds: testIds);
  }
}