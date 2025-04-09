import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/students/data/datasources/students_ds.dart';
import 'package:moatmat_teacher/Features/students/data/datasources/students_local_ds.dart';
import 'package:moatmat_teacher/Features/students/data/responses/get_my_students_statistics_response.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/test_details.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/repository/students_repo.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

import '../../../outer_tests/domain/entities/outer_test.dart';
import '../responses/get_my_students_response.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  final StudentsDS dataSource;
  final StudentsLocalDS localDataSource;

  StudentsRepositoryImpl({required this.dataSource, required this.localDataSource});
  @override
  Future<Either<Exception, GetMyStudentsResponse>> getMyStudents({
    required bool excludeCourseSubscribers,
    required bool excludeBanks,
    required bool excludeTests,
  }) async {
    try {
      var res = await dataSource.getMyStudents(
        excludeBanks: excludeBanks,
        excludeTests: excludeTests,
        excludeCourseSubscribers: excludeCourseSubscribers,
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, GetMyStudentsStatisticsResponse>> getMyStudentsStatistics({
    required List<UserData> students,
  }) async {
    try {
      var res = await dataSource.getMyStudentsStatistics(
        students: students,
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<UserData>>> getRepositoryStudents({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) async {
    try {
      var res = await dataSource.getRepositoryStudents(
        test: test,
        outerTest: outerTest,
        bank: bank,
        update: update,
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Result>>> getStudentResults({required String id, required bool update}) async {
    try {
      var res = await dataSource.getStudentResults(id: id, update: update);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Result>>> getRepositoryResults({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) async {
    try {
      var res = await dataSource.getRepositoryResults(
        test: test,
        outerTest: outerTest,
        bank: bank,
        update: update,
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<UserData>>> searchInMyStudents({
    required String text,
    required bool update,
  }) async {
    try {
      var res = await dataSource.searchInMyStudents(text: text, update: update);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  RepositoryDetails getRepositoryDetails({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required List<Result> results,
    required bool update,
  }) {
    return localDataSource.getRepositoryDetails(
      test: test,
      outerTest: outerTest,
      bank: bank,
      results: results,
    );
  }

  @override
  Future<Either<Exception, double>> getRepositoryAverage({
    required String? testId,
    required String? bankId,
    required String? outerTestId,
    required bool update,
  }) async {
    try {
      var res = await dataSource.getRepositoryAverage(
        testId: testId,
        bankId: bankId,
        outerTestId: outerTestId,
        update: update,
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteRepositoryResults({
    required List<int>? results,
    required int? testId,
    required int? bankId,
    required int? outerTestId,
  }) async {
    try {
      await dataSource.deleteRepositoryResults(
        results: results,
        testId: testId,
        outerTestId: outerTestId,
        bankId: bankId,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<UserData>>> getMyStudentsByIds({required List<String> ids}) async {
    try {
      var res = await dataSource.getMyStudentsByIds(ids: ids);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> addResults({
    required List<Result> results,
  }) async {
    try {
      var res = await dataSource.addResults(results: results);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
