import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

abstract class BucketsRepository {
  //
  Future<Either<Exception, String>> uploadFile({
    required String id,
    required String path,
    required String bucket,
    required String material,
    String? name,
  });
  //
  Future<Either<Exception, Unit>> deleteFile({
    required String link,
    required String bucket,
  });
  //
  Future<Either<Exception, Unit>> deleteTestFiles({
    required Test oldTest,
    required Test newTest,
  });
  //
  Future<Either<Exception, Unit>> deleteBanksFiles({
    required Bank oldBank,
    required Bank newBank,
  });
}
