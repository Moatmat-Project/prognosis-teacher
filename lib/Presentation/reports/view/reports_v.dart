import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Presentation/banks/views/add_bank_view.dart';
import 'package:moatmat_teacher/Presentation/reports/state/reports/reports_cubit.dart';
import 'package:moatmat_teacher/Presentation/reports/view/explore_question_v.dart';
import 'package:moatmat_teacher/Presentation/tests/views/add_test_vew.dart';
import '../widgets/report_tile_w.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    //
    context.read<ReportsCubit>().init();
    //
    context.read<ReportsCubit>().setOldLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الابلاغات"),
      ),
      body: BlocConsumer<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state is ReportsExploreBank) {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => ExploreQuestionView(
                      bank: state.bank,
                      reportData: state.reportData,
                    ),
                  ),
                )
                .then((value) => init());
          }
          if (state is ReportsExploreTest) {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => ExploreQuestionView(
                      test: state.test,
                      reportData: state.reportData,
                    ),
                  ),
                )
                .then((value) => init());
          }
        },
        builder: (context, state) {
          if (state is ReportsInitial) {
            return ListView.builder(
              itemCount: state.reports.length,
              itemBuilder: (context, index) => ReportTileWidget(
                report: state.reports[index],
                onDelete: () {
                  context.read<ReportsCubit>().deleteReport(
                        state.reports[index],
                      );
                },
                onExploreTest: () {
                  context.read<ReportsCubit>().onExploreTest(
                        state.reports[index],
                      );
                },
                onExploreBank: () {
                  context.read<ReportsCubit>().onExploreBank(
                        state.reports[index],
                      );
                },
              ),
            );
          } else if (state is ReportsError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(state.error.toString()),
              ),
            );
          } else if (state is ReportsNotFound) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text("لم يتم العثور على الاختبار/البنك المطلوب"),
              ),
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
