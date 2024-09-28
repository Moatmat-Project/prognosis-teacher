part of 'add_bank_cubit.dart';

sealed class AddBankState extends Equatable {
  const AddBankState();

  @override
  List<Object?> get props => [];
}

final class AddBankLoading extends AddBankState {
  final String? details;

  const AddBankLoading({this.details});
  @override
  List<Object?> get props => [details];
}

final class AddBankDenied extends AddBankState {
  const AddBankDenied();
  @override
  List<Object?> get props => [];
}

final class AddBankError extends AddBankState {
  final Exception exception;

  const AddBankError({required this.exception});

  @override
  List<Object?> get props => [exception];
}

final class AddBankProperties extends AddBankState {
  final BankProperties? properties;

  const AddBankProperties({required this.properties});

  @override
  List<Object?> get props => [properties];
}

final class AddBankInformation extends AddBankState {
  final BankInformation? information;

  const AddBankInformation({required this.information});
  @override
  List<Object?> get props => [information];
}

final class AddBankQuestions extends AddBankState {
  final List<Question> questions;

  const AddBankQuestions({required this.questions});

  @override
  List<Object?> get props => [questions];
}

final class AddBankDone extends AddBankState {
  @override
  List<Object?> get props => [];
}

final class AddBankPickFiles extends AddBankState {
  final List<String> files;
  const AddBankPickFiles({required this.files});
  @override
  List<Object?> get props => [files];
}
