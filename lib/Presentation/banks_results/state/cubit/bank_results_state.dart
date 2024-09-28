part of 'bank_results_cubit.dart';

sealed class BankResultsState extends Equatable {
  const BankResultsState();

  @override
  List<Object> get props => [];
}

final class BankResultsLoading extends BankResultsState {
  const BankResultsLoading();
}

final class BankResultsError extends BankResultsState {
  final String details;
  const BankResultsError(this.details);
}

final class BankResultsInitial extends BankResultsState {
  final RepositoryDetails details;

  const BankResultsInitial({required this.details});
}
