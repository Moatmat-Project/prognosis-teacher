import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/get_my_banks_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/get_outer_tests_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_my_tests_uc.dart';

import '../../../../Features/students/domain/entities/result.dart';

part 'student_reports_state.dart';

class StudentReportsCubit extends Cubit<StudentReportsState> {
  StudentReportsCubit() : super(StudentReportsLoading());
  //
  List<Result> testsResults = [];
  List<Result> banksResults = [];
  List<Result> outerTestsResults = [];
  //
  List<Test> tests = [];
  List<Bank> banks = [];
  List<OuterTest> outerTests = [];
  //
  List<ReportItem> testsReportInfo = [];
  List<ReportItem> banksReportInfo = [];
  List<ReportItem> outerTestsReportInfo = [];
  //
  init(List<Result> results) async {
    //
    testsResults == [];
    banksResults = [];
    outerTestsResults = [];
    tests = [];
    banks = [];
    outerTests = [];
    testsReportInfo = [];
    banksReportInfo = [];
    outerTestsReportInfo = [];

    //
    emit(StudentReportsLoading());
    // filter results
    testsResults = results.where((result) => result.testId != null).toList();
    banksResults = results.where((result) => result.bankId != null).toList();
    outerTestsResults = results.where((result) => result.outerTestId != null).toList();
    //
    await locator<GetMyTestsUC>().call().then((value) {
      value.fold(
        (l) {},
        (r) => tests = r,
      );
    });
    //
    await locator<GetMyBanksUC>().call().then((value) {
      value.fold(
        (l) {},
        (r) => banks = r,
      );
    });
    //
    await locator<GetOuterTestsUseCase>().call().then((value) {
      value.fold(
        (l) {},
        (r) => outerTests = r,
      );
    });
    //
    for (var t in tests) {
      testsReportInfo.add(ReportItem(
        id: t.id,
        title: t.information.title,
        results: testsResults.where((result) => result.testId == t.id).toList(),
      ));
    }
    //
    for (var b in banks) {
      banksReportInfo.add(ReportItem(
        id: b.id,
        title: b.information.title,
        results: banksResults.where((result) => result.bankId == b.id).toList(),
      ));
    }
    //
    for (var o in outerTests) {
      outerTestsReportInfo.add(ReportItem(
        id: o.id,
        title: o.information.title,
        results: banksResults.where((result) => result.bankId == o.id).toList(),
      ));
    }
    //
    emit(StudentReportsInitial(
      testsReportInfo: testsReportInfo,
      banksReportInfo: banksReportInfo,
      outerTestsReportInfo: outerTestsReportInfo,
    ));
    //
  }
}

class ReportItem {
  final int id;
  final String title;
  final List<Result> results;

  ReportItem({
    required this.id,
    required this.title,
    required this.results,
  });
}
