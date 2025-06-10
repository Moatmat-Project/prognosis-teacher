part of 'student_reports_cubit.dart';

sealed class StudentReportsState extends Equatable {
  const StudentReportsState();

  @override
  List<Object> get props => [];
}

final class StudentReportsLoading extends StudentReportsState {}

final class StudentReportsInitial extends StudentReportsState {
  final List<ReportItem> testsReportInfo;
  final List<ReportItem> banksReportInfo;
  final List<ReportItem> outerTestsReportInfo;

  const StudentReportsInitial({required this.testsReportInfo, required this.banksReportInfo, required this.outerTestsReportInfo});

  @override
  List<Object> get props => [testsReportInfo, banksReportInfo, outerTestsReportInfo];
}
