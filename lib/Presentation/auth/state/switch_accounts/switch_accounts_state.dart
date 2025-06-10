part of 'switch_accounts_bloc.dart';

sealed class SwitchAccountsState extends Equatable {
  const SwitchAccountsState();

  @override
  List<Object> get props => [];
}

final class SwitchAccountsLoading extends SwitchAccountsState {}

final class SwitchAccountsInitial extends SwitchAccountsState {
  final List<CachedCredentials> accounts;

  const SwitchAccountsInitial({required this.accounts});
}
