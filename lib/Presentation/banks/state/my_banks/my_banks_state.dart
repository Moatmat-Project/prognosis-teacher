part of 'my_banks_cubit.dart';

sealed class MyBanksState extends Equatable {
  const MyBanksState();

  @override
  List<Object> get props => [];
}

final class MyBanksLoading extends MyBanksState {}

final class MyBanksError extends MyBanksState {
  final Exception exception;

  const MyBanksError({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class MyBanksInitial extends MyBanksState {
  final List<Bank> banks;

  const MyBanksInitial({required this.banks});

  @override
  List<Object> get props => [banks];
}
