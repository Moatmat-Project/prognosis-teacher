import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/services/cache/cache_manager.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/cached_credentials.dart';

import '../../../../Core/services/cache/cache_constant.dart';
import '../../../../Features/auth/data/models/cached_credentials_model.dart';

part 'switch_accounts_event.dart';
part 'switch_accounts_state.dart';

class SwitchAccountsBloc extends Bloc<SwitchAccountsEvent, SwitchAccountsState> {
  SwitchAccountsBloc() : super(SwitchAccountsLoading()) {
    on<SwitchAccountsLoadEvent>(_onSwitchAccountsLoadEvent);
    on<SwitchAccountsPickAccountEvent>(_onSwitchAccountsPickAccountEvent);
    on<SwitchAccountsRemoveAccountEvent>(_onSwitchAccountsRemoveAccountEvent);
  }

  ///
  _onSwitchAccountsLoadEvent(SwitchAccountsLoadEvent event, Emitter<SwitchAccountsState> emit) async {
    //
    emit(SwitchAccountsLoading());
    //
    final List<CachedCredentials> accounts = await _getCachedAccounts();
    //
    emit(SwitchAccountsInitial(accounts: accounts));
  }

  ///
  _onSwitchAccountsPickAccountEvent(SwitchAccountsPickAccountEvent event, Emitter<SwitchAccountsState> emit) {}

  ///
  _onSwitchAccountsRemoveAccountEvent(SwitchAccountsRemoveAccountEvent event, Emitter<SwitchAccountsState> emit) {}

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
    accounts = cachedConditionals.map((e) => CachedCredentialsModel.fromJson(e )).toList();
    //
    return accounts;
  }

  ///
  Future<void> addToSavedConditionals(String email, String password) async {
    //
    List<Map> cachedConditionals = [];
    //
    if (locator<CacheManager>()().exist(CacheConstant.cachedCredentialKey)) {
      cachedConditionals = await locator<CacheManager>()().read(CacheConstant.cachedCredentialKey);
    }
    //
    cachedConditionals.removeWhere((e) => e["email"] == email);
    //
    cachedConditionals.add(CachedCredentialsModel(email: email, password: password).toJson());
    //
    await locator<CacheManager>()().write(CacheConstant.cachedCredentialKey, cachedConditionals);
    //
    return;
  }
}
