part of 'outer_test_information_cubit.dart';

sealed class OuterTestInformationState extends Equatable {
  const OuterTestInformationState();

  @override
  List<Object> get props => [];
}

final class OuterTestInformationLoading extends OuterTestInformationState {}

final class OuterTestInformationError extends OuterTestInformationState {
  final String? message;

  const OuterTestInformationError({required this.message});
}

final class OuterTestInformationInitial extends OuterTestInformationState {
  final OuterTest test;
  

  const OuterTestInformationInitial({required this.test, });

  @override
  List<Object> get props => [test];
}
