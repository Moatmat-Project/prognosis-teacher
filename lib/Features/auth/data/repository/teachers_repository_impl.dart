import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../domain/entites/teacher_data.dart';
import '../../domain/repository/teachers_repository.dart';
import '../data_source/users_ds.dart';

class TeachersRepositoryImpl implements TeacherRepository {
  final TeachersDataSource dataSource;

  TeachersRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, TeacherData>> getTeacherData({String? email}) async {
    try {
      var res = await dataSource.getTeacherData(email: email);
      return right(res);
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, TeacherData>> signIn({
    required String email,
    required String password,
  }) async {
    //
    try {
      var res = await dataSource.signIn(
        email: email,
        password: password,
      );
      return right(res);
    } on AuthException catch (e) {
      print(e);
      if (e.message == "Invalid login credentials") {
        return left(const InvalidDataFailure());
      }
      return left(const AnonFailure());
    } on Exception catch (e) {
      print(e);
      // خطا بالانترنت
      return left(const AnonFailure());
    }
    //
  }

  @override
  Future<Either<Failure, TeacherData>> signUp({
    required TeacherData teacherData,
    required String password,
  }) async {
    //
    try {
      var res = await dataSource.signUp(
        teacherData: teacherData,
        password: password,
      );
      //
      return right(res);
    } on AuthException catch (e) {
      if (e.message.contains("User already registered")) {
        return left(const UserAlreadyExcitedFailure());
      } else if (e.message.contains("invalid format")) {
        return left(const InvalidDataFailure());
      }
      return left(const AnonFailure());
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTeacherData({
    required TeacherData teacherData,
  }) async {
    try {
      var res = await dataSource.updateTeacherData(teacherData: teacherData);
      return right(res);
    } on Exception catch (e) {
      debugPrint(e.toString());

      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    try {
      var res = await dataSource.resetPassword(
        email: email,
        password: password,
        token: token,
      );
      return right(res);
    } on Exception catch (e) {
      print(e);
      return left(const AnonFailure());
    }
  }

  @override
  Future<Either<Failure, UserData>> getUserDataData({required String id, bool isUuid = true}) async {
    try {
      var res = await dataSource.getUserDataData(id: id, isUuid: isUuid);
      return right(res);
    } on Exception catch (e) {
      print("e is $e");
      return left(const AnonFailure());
    }
  }
}
