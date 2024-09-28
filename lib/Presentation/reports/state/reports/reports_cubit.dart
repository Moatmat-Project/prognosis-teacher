import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/get_bank_by_id_uc.dart';
import 'package:moatmat_teacher/Features/reports/domain/entities/reposrt_data.dart';
import 'package:moatmat_teacher/Features/reports/domain/usecases/delete_report_uc.dart';
import 'package:moatmat_teacher/Features/reports/domain/usecases/get_reports_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_test_by_id_uc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsLoading());
  List<ReportData> reports = [];
  init() async {
    emit(ReportsLoading());
    var res = await locator<GetReportsUC>().call();
    res.fold(
      (l) => emit(ReportsError(error: l)),
      (r) async {
        reports = r;
        emit(ReportsInitial(reports: r, newReports: await newReports()));
      },
    );
  }

  deleteReport(ReportData reportData) async {
    emit(ReportsLoading());
    var res = await locator<DeleteReportUC>().call(reportData: reportData);
    res.fold(
      (l) => emit(ReportsError(error: l)),
      (r) {
        init();
      },
    );
  }

  onExploreTest(ReportData data) async {
    emit(ReportsLoading());
    var res = await locator<GetTestByIdUC>().call(
      testId: data.testId!,
      update: true,
    );
    res.fold(
      (l) {
        emit(ReportsError(error: l));
      },
      (r) {
        if (r != null) {
          emit(ReportsExploreTest(test: r, reportData: data));
        } else {
          emit(const ReportsNotFound());
        }
      },
    );
  }

  onExploreBank(ReportData data) async {
    emit(ReportsLoading());
    var res = await locator<GetBankByIdUC>().call(
      bankId: data.bankId!,
      update: true,
    );
    res.fold(
      (l) => emit(ReportsError(error: l)),
      (r) {
        if (r != null) {
          emit(ReportsExploreBank(bank: r, reportData: data));
        }
      },
    );
  }

  newReports() async {
    //
    int oldLength = 0, newLength = reports.length;
    //
    oldLength = await getOldLength();
    //
    return (oldLength != newLength);
    //
  }

  void setOldLength() async {
    //
    final sp = await SharedPreferences.getInstance();
    //
    sp.setInt("reports_length", reports.length);
    //
    return;
  }

  Future<int> getOldLength() async {
    //
    final sp = await SharedPreferences.getInstance();
    //
    int length = sp.getInt("reports_length") ?? 0;
    //
    return length;
  }
}
