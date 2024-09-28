import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/buckets/data/datasources/buckets_remote_ds.dart';
import 'package:moatmat_teacher/Features/buckets/domain/repository/buckets_repo.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

class BucketsRepositoryImpl implements BucketsRepository {
  final BucketsRemoteDS dataSource;

  BucketsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Exception, Unit>> deleteFile({
    required String link,
    required String bucket,
  }) async {
    try {
      var res = await dataSource.deleteFile(link: link, bucket: bucket);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, String>> uploadFile({
    required String material,
    required String id,
    required String path,
    required String bucket,
    String? name,
  }) async {
    try {
      var res = await dataSource.uploadFile(
        material: material,
        id: id,
        path: path,
        bucket: bucket,
        name: name
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteBanksFiles(
      {required Bank oldBank, required Bank newBank}) async {
    try {
      await dataSource.deleteBanksFiles(
        oldBank: oldBank,
        newBank: newBank,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteTestFiles(
      {required Test oldTest, required Test newTest}) async {
    try {
      await dataSource.deleteTestFiles(
        oldTest: oldTest,
        newTest: newTest,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
