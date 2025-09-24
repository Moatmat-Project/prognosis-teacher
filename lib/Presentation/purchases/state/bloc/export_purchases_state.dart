part of 'export_purchases_bloc.dart';

class ExportPurchasesInitial extends Equatable {
  final String? message;
  final bool isLoading;
  final DateTime? starting, ending;

  const ExportPurchasesInitial({
    this.message,
    required this.isLoading,
    this.starting,
    this.ending,
  });

  ExportPurchasesInitial copyWith({
    bool? isLoading,
    String? message,
    DateTime? starting,
    DateTime? ending,
  }) {
    return ExportPurchasesInitial(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      starting: starting ?? this.starting,
      ending: ending ?? this.ending,
    );
  }

  @override
  List<Object?> get props => [isLoading, message, starting, ending];
}
