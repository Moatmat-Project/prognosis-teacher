part of 'switch_accounts_bloc.dart';

final class SwitchAccountsEvent extends Equatable {
  const SwitchAccountsEvent();

  @override
  List<Object> get props => [];
}

final class SwitchAccountsLoadEvent extends SwitchAccountsEvent {
  const SwitchAccountsLoadEvent();

  @override
  List<Object> get props => [];
}

final class SwitchAccountsPickAccountEvent extends SwitchAccountsEvent {
  const SwitchAccountsPickAccountEvent(this.cachedCredentials);
  final CachedCredentials cachedCredentials;
  @override
  List<Object> get props => [];
}

final class SwitchAccountsRemoveAccountEvent extends SwitchAccountsEvent {
  const SwitchAccountsRemoveAccountEvent(this.cachedCredentials);
  final CachedCredentials cachedCredentials;
  @override
  List<Object> get props => [];
}
