import 'package:dartz/dartz.dart';

import '../../../banks/domain/entities/bank.dart';
import '../../../tests/domain/entities/test/test.dart';
import '../entities/purchase_item.dart';

abstract class PurchasesRepository {
  //
  Future<Either<Exception, List<PurchaseItem>>> testPurchases({
    required Test test,
  });
  //
  Future<Either<Exception, List<PurchaseItem>>> bankPurchases({
    required Bank bank,
  });
  //
  Future<Either<Exception, List<PurchaseItem>>> teacherPurchases({
    required String email,
  });
}
