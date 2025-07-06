
import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/reply_comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

class GetRepliesUc {
  final TestsRepository repository;

  GetRepliesUc({required this.repository});

  Future<Either<Exception, List<ReplyComment>>> call({
    required int commentId,
  }) async {
    return await repository.getReplies(
      commentId: commentId,
    );
  }
}
