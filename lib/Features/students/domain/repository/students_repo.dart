import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/test_details.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../banks/domain/entities/bank.dart';
import '../../../outer_tests/domain/entities/outer_test.dart';

abstract class StudentsRepository {
  //
  // get my students
  Future<Either<Exception, List<UserData>>> getMyStudents({
    required bool update,
  });
  // get my students by ids
  Future<Either<Exception, List<UserData>>> getMyStudentsByIds({
    required List<String> ids,
  });
  // get test students
  Future<Either<Exception, List<UserData>>> getRepositoryStudents({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  });
  //
  // search in my students
  Future<Either<Exception, List<UserData>>> searchInMyStudents({
    required String text,
    required bool update,
  });
  //
  // get student results
  Future<Either<Exception, List<Result>>> getStudentResults({
    required String id,
    required bool update,
  });
  //
  // get test results
  Future<Either<Exception, List<Result>>> getRepositoryResults({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  });
  // delete results
  Future<Either<Exception, Unit>> deleteRepositoryResults({
    required List<int>? results,
    required int? bankId,
    required int? testId,
    required int? outerTestId,
  });
  //
  RepositoryDetails getRepositoryDetails({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
    required List<Result> results,
  });
  //

  //
  Future<Either<Exception, double>> getRepositoryAverage({
    required String? testId,
    required String? bankId,
    required String? outerTestId,
    required bool update,
  });
  Future<Either<Exception, Unit>> addResults({
    required List<Result> results,
  });
}
