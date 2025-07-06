import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

class DeleteCommentUc {
  final TestsRepository repository;

  DeleteCommentUc({required this.repository});

  Future<Either<Exception, Unit>> call({
    required int commentId,
  }) async {
    return await repository.deleteComment(
      commentId: commentId,
    );
  }
}