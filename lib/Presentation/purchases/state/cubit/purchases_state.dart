part of 'purchases_cubit.dart';

sealed class PurchasesState extends Equatable {
  const PurchasesState();

  @override
  List<Object> get props => [];
}

final class PurchasesLoading extends PurchasesState {}

final class PurchasesInitial extends PurchasesState {
  final List<PurchaseItem> purchases;
  final String? error;

  const PurchasesInitial({
    required this.purchases,
    this.error,
  });
}
