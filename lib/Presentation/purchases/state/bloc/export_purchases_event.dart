part of 'export_purchases_bloc.dart';

abstract class ExportPurchasesEvent extends Equatable {
  const ExportPurchasesEvent();

  @override
  List<Object?> get props => [];
}

class ExportPurchasesRequested extends ExportPurchasesEvent {
  final List<PurchaseItem> purchases;

  const ExportPurchasesRequested({required this.purchases});

  @override
  List<Object?> get props => [purchases];
}
