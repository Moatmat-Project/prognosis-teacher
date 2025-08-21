part of 'purchases_cubit.dart';

final class PurchasesInitial extends Equatable {
  final List<PurchaseItem> purchases;
  final List<PurchaseItem> filtered;
  final DateTime? starting, ending;
  final String? error;
  final bool isLoading;

  const PurchasesInitial({
    required this.purchases,
    this.starting,
    this.ending,
    required this.filtered,
    this.error,
    required this.isLoading,
  });

  PurchasesInitial copyWith({
    DateTime? starting,
    DateTime? ending,
    List<PurchaseItem>? purchases,
    List<PurchaseItem>? filtered,
    String? error,
    required bool isLoading,
  }) {
    return PurchasesInitial(
      starting: starting ?? this.starting,
      ending: ending ?? this.ending,
      purchases: purchases ?? this.purchases,
      filtered: filtered ?? this.filtered,
      error: error ?? this.error,
      isLoading:this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        purchases,
        filtered,
        starting,
        ending,
        error,
        isLoading,
      ];
}
