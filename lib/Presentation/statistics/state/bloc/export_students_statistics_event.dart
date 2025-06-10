part of 'export_students_statistics_bloc.dart';

final class ExportStudentsStatisticsEvent extends Equatable {
  const ExportStudentsStatisticsEvent();

  @override
  List<Object> get props => [];
}

final class InitializeStudentsStatisticsEvent extends ExportStudentsStatisticsEvent {
  const InitializeStudentsStatisticsEvent(this.students);
  final List<UserData> students;
  @override
  List<Object> get props => [];
}

final class PickTestsEvent extends ExportStudentsStatisticsEvent {
  const PickTestsEvent();
  @override
  List<Object> get props => [];
}

final class PickSetsEvent extends ExportStudentsStatisticsEvent {
  const PickSetsEvent();
  @override
  List<Object> get props => [];
}

final class SetTestsEvent extends ExportStudentsStatisticsEvent {
  const SetTestsEvent(this.selectedTests);
  final List<(int, String)> selectedTests;
  @override
  List<Object> get props => [];
}

final class SetSetsEvent extends ExportStudentsStatisticsEvent {
  const SetSetsEvent(this.selectedSets);
  final List<AttendanceSet> selectedSets;
  @override
  List<Object> get props => [];
}

final class ExportStatisticsExcelEvent extends ExportStudentsStatisticsEvent {
  const ExportStatisticsExcelEvent();
  @override
  List<Object> get props => [];
}

final class ExportStatisticsPdfEvent extends ExportStudentsStatisticsEvent {
  const ExportStatisticsPdfEvent();
  @override
  List<Object> get props => [];
}
