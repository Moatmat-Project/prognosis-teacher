import 'package:dartz/dartz.dart';
import '../entities/purchase_item.dart';
import '../repository/purchases_rep.dart';

class TeacherPurchasesUC {
  final PurchasesRepository repository;

  TeacherPurchasesUC({required this.repository});

  Future<Either<Exception, List<PurchaseItem>>> call({required String email}) {
    return repository.teacherPurchases(email: email);
  }
}
