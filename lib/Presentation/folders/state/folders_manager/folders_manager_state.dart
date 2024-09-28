part of 'folders_manager_cubit.dart';

final class FoldersManagerState extends Equatable {
  final List<String> folders;
  final List<Test> tests;
  final List<Bank> banks;
  final bool canPop, isLoading;

  const FoldersManagerState({
    this.canPop = false,
    this.folders = const [],
    this.tests = const [],
    this.banks = const [],
    this.isLoading = true,
  });
  @override
  List<Object> get props => [folders, tests, banks, canPop, isLoading];
}
