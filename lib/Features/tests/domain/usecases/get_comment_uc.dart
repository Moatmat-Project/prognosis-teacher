import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

class GetCommentUc {
  final TestsRepository repository;

  GetCommentUc({required this.repository});

  Future<Either<Exception, List<Comment>>> call({
    required int videoId,
  }) async {
    return await repository.getComment(
      videoId: videoId,
    );
  }
}
