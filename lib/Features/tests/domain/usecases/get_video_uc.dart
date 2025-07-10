
import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

class GetVideoUc {
  final TestsRepository repository;

  GetVideoUc({required this.repository});

  Future<Either<Exception, String>> call({
    required int videoId,
  }) async {
    return await repository.getVideo(
      videoId: videoId,
    );
  }
}