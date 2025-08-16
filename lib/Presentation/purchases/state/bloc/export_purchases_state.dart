part of 'export_purchases_bloc.dart';

abstract class ExportPurchasesState extends Equatable {
  const ExportPurchasesState();

  @override
  List<Object?> get props => [];
}

class ExportPurchasesInitial extends ExportPurchasesState {}

class ExportPurchasesLoading extends ExportPurchasesState {}

class ExportPurchasesSuccess extends ExportPurchasesState {
  final String filePath;
  const ExportPurchasesSuccess({required this.filePath});
  
  @override
  List<Object?> get props => [filePath];
}

class ExportPurchasesFailure extends ExportPurchasesState {
  final String message;
  const ExportPurchasesFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
