part of 'export_students_statistics_bloc.dart';

sealed class ExportStudentsStatisticsState extends Equatable {
  const ExportStudentsStatisticsState({
    this.message,
    required this.sets,
    required this.tests,
    required this.selectedTests,
    required this.selectedSets,
    required this.studentsRows,
    required this.students,
  });
  final String? message;
  final List<AttendanceSet> sets, selectedSets;
  final List<(int, String)> tests, selectedTests;
  final List<StudentRowDetails> studentsRows;
  final List<UserData> students;
  @override
  List<Object?> get props => [
        message,
        sets,
        tests,
        selectedSets,
        selectedTests,
        studentsRows,
        students,
      ];
}

final class ExportStatisticsLoading extends ExportStudentsStatisticsState {
  ExportStatisticsLoading({ExportStudentsStatisticsState? state})
      : super(
          sets: state?.sets ?? List.empty(growable: true),
          tests: state?.tests ?? List.empty(growable: true),
          selectedTests: state?.selectedTests ?? List.empty(growable: true),
          studentsRows: state?.studentsRows ?? List.empty(growable: true),
          selectedSets: state?.selectedSets ?? List.empty(growable: true),
          students: state?.students ?? List.empty(growable: true),
          message: state?.message,
        );
}

final class ExportStatisticsInitial extends ExportStudentsStatisticsState {
  const ExportStatisticsInitial({
    super.message,
    required super.sets,
    required super.selectedTests,
    required super.selectedSets,
    required super.tests,
    required super.studentsRows,
    required super.students,
  });
}

final class ExportStatisticsCompleted extends ExportStudentsStatisticsState {
  final Excel excel;
  ExportStatisticsCompleted(this.excel)
      : super(
          sets: List.empty(growable: true),
          tests: List.empty(growable: true),
          selectedTests: List.empty(growable: true),
          selectedSets: List.empty(growable: true),
          studentsRows: List.empty(growable: true),
          students: List.empty(growable: true),
          message: null,
        );
}

final class ExportStatisticsPickTests extends ExportStudentsStatisticsState {
  const ExportStatisticsPickTests({
    super.message,
    required super.sets,
    required super.selectedTests,
    required super.selectedSets,
    required super.tests,
    required super.studentsRows,
    required super.students,
  });
}

final class ExportStatisticsPickSets extends ExportStudentsStatisticsState {
  const ExportStatisticsPickSets({
    super.message,
    required super.sets,
    required super.selectedTests,
    required super.selectedSets,
    required super.tests,
    required super.studentsRows,
    required super.students,
  });
}

final class ExportStatisticsProcessing extends ExportStudentsStatisticsState {
  const ExportStatisticsProcessing({
    super.message,
    required super.sets,
    required super.selectedTests,
    required super.selectedSets,
    required super.tests,
    required super.studentsRows,
    required super.students,
  });
}
