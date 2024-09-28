part of 'test_information_cubit.dart';

sealed class TestInformationState extends Equatable {
  const TestInformationState();

  @override
  List<Object> get props => [];
}

final class TestInformationLoading extends TestInformationState {}

final class TestInformationError extends TestInformationState {
  final String? message;

  const TestInformationError({required this.message});
}

final class TestInformationInitial extends TestInformationState {
  final Test test;
  final List<PurchaseItem> items;

  const TestInformationInitial({required this.test, required this.items});

  @override
  List<Object> get props => [items];
}
