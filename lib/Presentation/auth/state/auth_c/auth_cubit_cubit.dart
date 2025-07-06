import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:moatmat_teacher/Core/services/cache/cache_manager.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/cached_credentials.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/auth/domain/use_cases/update_teacher_data_uc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/cache/cache_constant.dart';
import '../../../../Features/auth/data/models/cached_credentials_model.dart';
import '../../../../Features/auth/domain/use_cases/get_teacher_data.dart';
import '../../../../Features/update/domain/entites/update_info.dart';
import '../../../../Features/update/domain/usecases/check_update_state_uc.dart';

part 'auth_cubit_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthLoading());
  init({bool forceSigning = false}) async {
    //
    emit(AuthLoading());
    //
    final res = await locator<CheckUpdateStateUC>().call();
    //
    res.fold(
      (l) {
        if (l is SocketException && Supabase.instance.client.auth.currentUser != null) {
          emit(const OfflineError());
        } else {
          emit(const AuthError());
        }
      },
      (r) {
        //
        injectUpdateInfo(r);
        //
        if (r.appVersion < r.currentVersion || r.appVersion < r.minimumVersion) {
          emit(AuthUpdate(updateInfo: r));
        } else {
          //
          if (forceSigning) {
            startAuth();
            return;
          }
          //
          var user = Supabase.instance.client.auth.currentUser;
          //
          if (user == null) {
            emit(AuthOnBoarding());
          } else {
            refresh();
          }
          //
        }
      },
    );
    //
  }

  injectUpdateInfo(UpdateInfo info) {
    if (!GetIt.instance.isRegistered<UpdateInfo>()) {
      locator.registerFactory<UpdateInfo>(() => info);
    } else {
      GetIt.instance.unregister<UpdateInfo>();
      locator.registerFactory<UpdateInfo>(() => info);
    }
  }

  void skipUpdate() {
    refresh();
  }

  refresh() async {
    //
    emit(AuthLoading());
    //
    locator<GetTeacherDataUC>().call().then((value) {
      value.fold(
        (l) {
          if (l is SocketException && Supabase.instance.client.auth.currentUser != null) {
            emit(const OfflineError());
          } else {
            emit(const AuthError());
          }
        },
        (r) async {
          if ((r.options.isTeacher ?? false)||kDebugMode) {
            injectTeacherData(r);
            emit(AuthDone());
          } else if(!kDebugMode){
            emit(
              const AuthError(
                error: "حساب غير مصرح \n تواصل على واتساب 0984993813 لتنشيط حسابك",
              ),
            );
            //
          }
        },
      );
    });
  }

  updateUserData(TeacherData teacherData) {
    injectTeacherData(teacherData);
    locator<UpdateTeacherDataUC>().call(teacherData: teacherData).then((value) {
      value.fold(
        (l) => null,
        (r) {
          injectTeacherData(teacherData);
        },
      );
    });
  }

  injectTeacherData(TeacherData teacherData) {
    // allow all
    if (!GetIt.instance.isRegistered<TeacherData>()) {
      locator.registerFactory<TeacherData>(() => teacherData);
    } else {
      GetIt.instance.unregister<TeacherData>();
      locator.registerFactory<TeacherData>(() => teacherData);
    }
  }

  //
  startAuth() async {
    emit(AuthStartAuth());
  }

  //
  startSignIn() async {
    emit(AuthSignIn(allowFastAuth: locator<CacheManager>()().exist(CacheConstant.cachedCredentialKey)));
  }

  //
  startSignUp() async {
    emit(AuthSignUP());
  }

  //
  startFastAuth() async {
    emit(AuthFastAuth(accounts: await _getCachedAccounts()));
  }

  //
  startRessetPassword() async {
    emit(AuthResetPassword());
  }

  //
  startSignOut() async {
    emit(AuthLoading());
    await locator<SupabaseClient>().auth.signOut();
    await startAuth();
  }

  //
  finishAuth() {
    init();
  }

  //
  ///
  Future<List<CachedCredentials>> _getCachedAccounts() async {
    //
    late final List cachedConditionals;
    late final List<CachedCredentials> accounts;
    //
    if (locator<CacheManager>()().exist(CacheConstant.cachedCredentialKey)) {
      cachedConditionals = await locator<CacheManager>()().read(CacheConstant.cachedCredentialKey);
    }
    //
    if (cachedConditionals.isEmpty) {
      return const [];
    }
    //
    accounts = cachedConditionals.map((e) => CachedCredentialsModel.fromJson(e)).toList();
    //
    return accounts;
  }
}
