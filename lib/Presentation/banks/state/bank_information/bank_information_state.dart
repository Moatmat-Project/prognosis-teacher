part of 'bank_information_cubit.dart';

sealed class BankInformationState extends Equatable {
  const BankInformationState();

  @override
  List<Object> get props => [];
}

final class BankInformationLoading extends BankInformationState {}

final class BankInformationError extends BankInformationState {
  final String? message;

  const BankInformationError({required this.message});
}

final class BankInformationInitial extends BankInformationState {
  final Bank bank;
  final List<PurchaseItem> items;

  const BankInformationInitial({
    required this.bank,
    required this.items,
  });

  @override
  List<Object> get props => [items];
}
