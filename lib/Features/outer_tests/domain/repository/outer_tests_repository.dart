import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';

abstract class OuterTestsRepository {
  //
  // get outer tests
  Future<Either<Failure, List<OuterTest>>> getOuterTests();
  //
  // get outer test
  Future<Either<Failure, OuterTest>> getOuterTestById({required int id});
  //
  // delete outer test
  Future<Either<Failure, Unit>> deleteOuterTest({required int id});
  //
  // add outer test
  Future<Either<Failure, Unit>> addOuterTest({required OuterTest test});
  //
  // update outer test
  Future<Either<Failure, Unit>> updateOuterTest({required OuterTest test});
}
