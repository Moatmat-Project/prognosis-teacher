import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/students/data/models/user_data_m.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../domain/entites/teacher_data.dart';
import '../models/teacher_data_m.dart';

abstract class TeachersDataSource {
  // signIn
  Future<TeacherData> signIn({
    required String email,
    required String password,
  });
  // signUp
  Future<TeacherData> signUp({
    required TeacherData teacherData,
    required String password,
  });
  //
  // update User Data
  Future<Unit> updateTeacherData({
    required TeacherData teacherData,
  });
  //
  // get teacher Data
  Future<TeacherData> getTeacherData({String? email});
  // get User Data
  Future<UserData> getUserDataData({required String id, bool isUuid = true});
  //
  Future<Unit> resetPassword({
    required String email,
    required String password,
    required String token,
  });
}

class TeachersDataSourceImpl implements TeachersDataSource {
  final SupabaseClient client;

  TeachersDataSourceImpl({required this.client});
  @override
  Future<TeacherData> getTeacherData({String? email}) async {
    //
    var query = client.from("teachers_data").select().eq("email", email ?? client.auth.currentUser!.email!.toLowerCase());
    //
    List res = await query;
    if (res.isNotEmpty) {
      final teacherData = TeacherDataModel.fromJson(res.first);
      return teacherData;
    } else {
      throw Exception();
    }
  }

  @override
  Future<Unit> updateTeacherData({
    required TeacherData teacherData,
  }) async {
    //
    final similarEmails = await Supabase.instance.client.from("teachers_data").select().eq("email", teacherData.email);
    //
    if (similarEmails.isEmpty) {
      //
      await insertTeacherData(teacherData: teacherData);
      return unit;
      //
    }
    //
    Map json = TeacherDataModel.fromClass(teacherData).toJson();
    //
    var query = client.from("teachers_data").update(json).eq("email", teacherData.email);
    //
    await query;
    //
    return unit;
  }

  Future<Unit> insertTeacherData({required TeacherData teacherData}) async {
    //
    Map jsonUserData = TeacherDataModel.fromClass(teacherData).toJson();
    //
    await client.from("teachers_data").insert(jsonUserData);
    //
    return unit;
  }

  @override
  Future<TeacherData> signIn({
    required String email,
    required String password,
  }) async {
    email = email.toLowerCase().trim();
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    String? uuid = client.auth.currentUser?.id;
    if (uuid != null) {
      return await getTeacherData();
    } else {
      throw AnonException();
    }
  }

  @override
  Future<TeacherData> signUp({
    required TeacherData teacherData,
    required String password,
  }) async {
    //
    teacherData = teacherData.copyWith(email: teacherData.email.toLowerCase().trim());
    //
    await client.auth.signUp(
      email: teacherData.email,
      password: password,
    );
    //
    String? uuid = client.auth.currentUser?.id;
    if (uuid != null) {
      await updateTeacherData(teacherData: teacherData);
      return teacherData;
    } else {
      throw AnonException();
    }
  }

  @override
  Future<Unit> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    var client = Supabase.instance.client;
    await client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    );
    await client.auth.updateUser(
      UserAttributes(password: password),
    );
    return unit;
  }

  @override
  Future<UserData> getUserDataData({required String id, bool isUuid = true}) async {
    //
    PostgrestList query;
    if (isUuid) {
      query = await client.from("users_data").select().eq("uuid", id);
    } else {
      query = await client.from("users_data").select().eq("id", id);
    }
    //
    List res = query;
    if (res.isNotEmpty) {
      final userData = UserDataModel.fromJson(res.first);
      return userData;
    } else {
      throw Exception("empty");
    }
  }
}
