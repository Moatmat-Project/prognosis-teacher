
import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/scanner/domain/repository/scanner_repo.dart';

class DeleteOuterTestsUC {
  final ScannerRepository repository;

  DeleteOuterTestsUC({required this.repository});

  Future<Either<Exception, Unit>> call({required String name}) async {
    return repository.deleteOuterTest(name:name);
  }
}
