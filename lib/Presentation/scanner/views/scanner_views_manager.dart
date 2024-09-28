import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_outer_tests_v.dart';
import 'package:moatmat_teacher/Presentation/scanner/state/scanner_views_manager_cubit.dart';
import 'package:moatmat_teacher/Presentation/scanner/views/results_v.dart';
import 'package:moatmat_teacher/Presentation/scanner/views/set_answers_v.dart';
import 'package:moatmat_teacher/Presentation/scanner/views/set_settings_v.dart';
import 'package:moatmat_teacher/Presentation/tests/widgets/outer_test_tile_w.dart';

import '../../../Features/scanner/domain/entities/paper.dart';
import 'scanning_v.dart';
import 'set_up_result_v.dart';

class ScannerViewsManager extends StatefulWidget {
  const ScannerViewsManager({super.key});

  @override
  State<ScannerViewsManager> createState() => _ScannerViewsManagerState();
}

class _ScannerViewsManagerState extends State<ScannerViewsManager> {
  @override
  void initState() {
    context.read<ScannerViewsManagerCubit>().init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ScannerViewsManagerCubit, ScannerViewsManagerState>(
        listener: (context, state) {
          if (state is ScannerViewsManagerPapers) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                ),
              );
            }
          } else if (state is ScannerViewsManagerUploadSucceed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم الرفع بنجاح"),
              ),
            );
            Navigator.of(context).pop();
          }
          if (state is ScannerViewsManagerDuplicatedPapers) {
            showAlert(
              context: context,
              title: "طالب مكرر",
              body: "تم العثور على تكرار برقم الطالب ، هل ترغب بحفظ النتيجة القديمة [${state.firstPaper.getMark()}] ام الجديدة [${state.secondPaper.getMark()}]؟",
              agreeBtn: "حفظ الجديدة",
              disagreeBtn: "حفظ القديمة",
              onAgree: () {
                // save old one
                context.read<ScannerViewsManagerCubit>().solveDuplicated(
                      null,
                      state.secondPaper,
                    );
              },
              onDisagree: () {
                // save new one
                context.read<ScannerViewsManagerCubit>().solveDuplicated(
                      state.firstPaper,
                      null,
                    );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is ScannerViewsManagerPickTest) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("اختر الاختبار للمتابعة"),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchInOuterTestsView(
                            onPick: (test) {
                              context.read<ScannerViewsManagerCubit>().setSettings(test);
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: state.tests.length,
                itemBuilder: (context, index) {
                  return OuterTestTileWidget(
                    test: state.tests[index],
                    onPick: () {
                      final test = state.tests[index];
                      context.read<ScannerViewsManagerCubit>().setSettings(test);
                    },
                  );
                },
              ),
            );
          }
          if (state is ScannerViewsManagerPapers) {
            return ScannerResultsView(state: state);
          } else if (state is ScannerViewsManagerScanning) {
            return ScanningView(state: state);
          } else if (state is ScannerViewsManagerError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(state.error),
              ),
            );
          } else if (state is ScannerViewsManagerSetUpPaper) {
            return SetUpPaperView(
              paper: state.paper,
              onSave: (paper) {
                context.read<ScannerViewsManagerCubit>().addPaper(paper.data);
              },
            );
          } else if (state is ScannerViewsManagerExplorePaper) {
            return SetUpPaperView(
              paper: state.paper,
              onSave: (paper) {
                context.read<ScannerViewsManagerCubit>().updatePaper(state.index, paper);
              },
            );
          }
          //
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              context.read<ScannerViewsManagerCubit>().showPapers();
            },
            child: Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }
}
