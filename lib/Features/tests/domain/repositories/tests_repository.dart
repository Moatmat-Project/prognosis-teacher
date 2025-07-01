import 'package:dartz/dartz.dart';
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
  });
  //
  Future<Either<Exception, int>> addVideo({
    required Video video,
  });
}
