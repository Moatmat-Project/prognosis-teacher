part of 'manage_group_tests_bloc.dart';

sealed class ManageGroupTestsState extends Equatable {
  const ManageGroupTestsState({
    required this.selectedTests,
    this.isLoading = false,
    this.canSaving = false,
    this.message,
  });
  final List<Test> selectedTests;
  final bool isLoading, canSaving;
  final String? message;
  @override
  List<Object?> get props => [
        selectedTests,
        isLoading,
        message,
        canSaving,
      ];
}

final class ManageGroupTestsLoading extends ManageGroupTestsState {
  const ManageGroupTestsLoading({super.selectedTests = const []}) : super();
}

final class ManageGroupTestsInitial extends ManageGroupTestsState {
  const ManageGroupTestsInitial({
    required super.selectedTests,
    super.isLoading = false,
    required super.canSaving,
    super.message,
  });
}

final class ManageGroupTestsPickTests extends ManageGroupTestsState {
  final List<Test> tests;
  final bool canPop;
  final List<String> folders;
  const ManageGroupTestsPickTests({
    this.tests = const [],
    this.folders = const [],
    super.selectedTests = const [],
    this.canPop = false,
    super.isLoading = false,
    required super.canSaving,
    super.message,
  });
  @override
  List<Object?> get props => [
        tests,
        folders,
        selectedTests,
        canPop,
        isLoading,
        message,
        canSaving,
      ];
}
