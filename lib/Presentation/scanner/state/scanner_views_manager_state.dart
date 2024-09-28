part of 'scanner_views_manager_cubit.dart';

sealed class ScannerViewsManagerState extends Equatable {
  const ScannerViewsManagerState();

  @override
  List<Object?> get props => [];
}

final class ScannerViewsManagerLoading extends ScannerViewsManagerState {}

final class ScannerViewsManagerError extends ScannerViewsManagerState {
  final String error;

  const ScannerViewsManagerError({required this.error});
}

final class ScannerViewsManagerPickTest extends ScannerViewsManagerState {
  final List<OuterTest> tests;

  const ScannerViewsManagerPickTest({required this.tests});
  @override
  List<Object?> get props => [tests];
}

final class ScannerViewsManagerScanning extends ScannerViewsManagerState {
  final PaperType paperType;
  const ScannerViewsManagerScanning({required this.paperType});
}

final class ScannerViewsManagerSetUpPaper extends ScannerViewsManagerState {
  final Paper paper;
  final List<int> answers;
  final List<Uint8List> images;

  const ScannerViewsManagerSetUpPaper({
    required this.answers,
    required this.images,
    required this.paper,
  });
}

final class ScannerViewsManagerExplorePaper extends ScannerViewsManagerState {
  //
  final int index;
  final Paper paper;

  //
  const ScannerViewsManagerExplorePaper({
    required this.index,
    required this.paper,
  });
}

final class ScannerViewsManagerPapers extends ScannerViewsManagerState {
  final List<Paper> papers;

  final String? error;

  const ScannerViewsManagerPapers({
    required this.papers,
    this.error,
  });

  @override
  List<Object?> get props => [papers, error];
}

final class ScannerViewsManagerUploadSucceed extends ScannerViewsManagerState {}

final class ScannerViewsManagerDuplicatedPapers extends ScannerViewsManagerState {
  final Paper firstPaper;
  final Paper secondPaper;

  const ScannerViewsManagerDuplicatedPapers({
    required this.firstPaper,
    required this.secondPaper,
  });
}
