import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/reply_comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';

abstract class TestsRepository {
  //
  Future<Either<Exception, Stream>> uploadTest({
    required Test test,
  });
  //
  Future<Either<Exception, Stream>> updateTest({
    required Test test,
  });
  //
  Future<Either<Exception, Unit>> deleteTest({
    required int testId,
  });
  //
  Future<Either<Exception, Test?>> getTestById({
    required int testId,
    required bool update,
  });
  //
  Future<Either<Exception, List<Test>>> getTestsByIds({
    required List<int> ids,
    required bool update,
  });
  //
  Future<Either<Exception, List<Test>>> getMyTests({
    required bool update,
    required bool queryIds,
  });
  //
  Future<Either<Exception, Video>> addVideo({
    required Video video,
  });
  //
  Future<Either<Exception, List<Comment>>> getComment({
    required int videoId,
  });
  //
  Future<Either<Exception, List<ReplyComment>>> getReplies({
    required int commentId,
  });
  //
  Future<Either<Exception, Unit>> deleteComment({
    required int commentId,
  });
  //
  Future<Either<Exception, Unit>> deleteReplies({
    required int replyId,
  });
  //
  Future<Either<Exception, String>> getVideo({
    required int videoId,
  });
  //
}
