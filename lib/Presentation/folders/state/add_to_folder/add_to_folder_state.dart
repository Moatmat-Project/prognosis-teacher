part of 'add_to_folder_cubit.dart';

final class AddToFolderState extends Equatable {
  const AddToFolderState({
    this.teacher,
    this.error,
    this.folders = const [],
    this.tests = const [],
    this.banks = const [],
    this.canPop = false,
    this.isLoading = false,
  });

  final String? teacher;
  final Failure? error;
  final List<Test> tests;
  final List<Bank> banks;
  final List<String> folders;
  final bool canPop, isLoading;

  AddToFolderState copyWith({
    String? teacher,
    Failure? error,
    List<Test>? tests,
    List<Bank>? banks,
    List<String>? folders,
    bool? canPop,
    bool? isLoading,
  }) {
    return AddToFolderState(
      teacher: teacher ?? this.teacher,
      error: error ?? this.error,
      tests: tests ?? this.tests,
      banks: banks ?? this.banks,
      folders: folders ?? this.folders,
      canPop: canPop ?? this.canPop,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        teacher,
        error,
        tests,
        banks,
        folders,
        canPop,
        isLoading,
      ];
}
