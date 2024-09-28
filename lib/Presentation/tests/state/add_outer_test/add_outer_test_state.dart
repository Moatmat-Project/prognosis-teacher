part of 'add_outer_test_cubit.dart';

sealed class AddOuterTestState extends Equatable {
  const AddOuterTestState();

  @override
  List<Object?> get props => [];
}

final class AddOuterTestLoading extends AddOuterTestState {
  final String? details;

  const AddOuterTestLoading({this.details});
  @override
  List<Object?> get props => [details];
}

final class AddOuterTestDenied extends AddOuterTestState {
  const AddOuterTestDenied();
  @override
  List<AddOuterTestDenied?> get props => [];
}

final class AddOuterTestError extends AddOuterTestState {
  final Failure exception;

  const AddOuterTestError({required this.exception});

  @override
  List<Object?> get props => [exception];
}

final class AddOuterTestInformation extends AddOuterTestState {
  final List<OuterTestForm> forms;
  final OuterTestInformation? information;

  const AddOuterTestInformation({
    required this.information,
    required this.forms,
  });
  @override
  List<Object?> get props => [information, forms];
}

final class AddOuterTestViewForms extends AddOuterTestState {
  final List<OuterTestForm> forms;

  const AddOuterTestViewForms({required this.forms});
  @override
  List<Object?> get props => [forms];
}

final class AddOuterTestEditForm extends AddOuterTestState {
  final OuterTestForm form;

  const AddOuterTestEditForm({required this.form});
  @override
  List<Object?> get props => [form];
}

final class AddOuterTestDone extends AddOuterTestState {}
