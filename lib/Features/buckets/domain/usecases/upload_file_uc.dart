import 'package:dartz/dartz.dart';

import '../repository/buckets_repo.dart';

class UploadFileUC {
  final BucketsRepository repository;

  UploadFileUC({required this.repository});

  Future<Either<Exception, String>> call({
    required String material,
    required String id,
    required String path,
    required String bucket,
    String? name,
  }) async {
    return await repository.uploadFile(
      material: material,
      id: id,
      path: path,
      bucket: bucket,
      name: name,
    );
  }
}
