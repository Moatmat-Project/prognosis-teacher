
import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

class DeleteReplyUc {
  final TestsRepository repository;

  DeleteReplyUc({required this.repository});

  Future<Either<Exception, Unit>> call({
    required int replyId,
  }) async {
    return await repository.deleteReplies(
      replyId: replyId,
    );
  }
}