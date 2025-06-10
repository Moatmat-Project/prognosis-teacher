import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/answers_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/id_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/row_bubbles.dart';
import 'package:moatmat_teacher/Presentation/scanner/widgets/answer_row_w.dart';
import 'package:moatmat_teacher/Presentation/scanner/widgets/form_row_w.dart';
import 'package:moatmat_teacher/Presentation/scanner/widgets/id_row_w.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Features/scanner/domain/entities/form_data.dart';
import '../state/scanner_views_manager_cubit.dart';

class SetUpPaperView extends StatefulWidget {
  const SetUpPaperView({
    super.key,
    required this.paper,
    required this.onSave,
  });
  //
  //
  final Paper paper;
  //
  //
  final void Function(Paper) onSave;
  //
  @override
  State<SetUpPaperView> createState() => _SetUpPaperViewState();
}

class _SetUpPaperViewState extends State<SetUpPaperView> {
  //
  bool loading = true;
  //
  int selectedForm = 0;
  //
  late IdData id;
  late AnswersData answers;
  late FormData form;

  //
  @override
  void initState() {
    //
    id = widget.paper.data.id;
    answers = widget.paper.data.answers;
    form = widget.paper.data.form;
    //
    //
    selectedForm = form.row.selected ?? 0;
    if (selectedForm + 1 > widget.paper.settings.answers.length) {
      selectedForm = 0;
    }
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        context.read<ScannerViewsManagerCubit>().showPapers();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: const Text(
            "مراجعة الورقة",
            style: TextStyle(
              //  مشهور
              fontSize: 14,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                widget.onSave(
                  Paper(
                    student: widget.paper.student,
                    settings: widget.paper.settings,
                    data: PaperData(
                      id: id,
                      answers: answers,
                      form: FormData(
                          row: form.row.copyWith(
                        selected: selectedForm,
                      )),
                    ),
                  ),
                );
              },
              icon: const Text(
                "حفظ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // //
                idBuilder(id: id),
                // //
                FormRowWidget(
                  selected: selectedForm,
                  rowBubbles: form.row,
                  onUpdate: (i) {
                    if (widget.paper.settings.answers.length > i) {
                      selectedForm = i;
                    } else {
                      showAlert(
                        context: context,
                        title: "لم يتم اعداد النموذج",
                        body: "لم يتم اعداد النموذج الذي ترغب باختياره!",
                        onAgree: () {},
                      );
                    }
                    setState(() {});
                    return;
                  },
                ),
                //
                const SizedBox(
                  height: SizesResources.s2,
                  width: double.infinity,
                ),
                // //
                ...List.generate(
                  widget.paper.settings.answers[selectedForm].length,
                  (index) {
                    final row = answers.rows[index];
                    final answer = widget.paper.settings.answers[selectedForm][index];
                    return AnswerRowWidget(
                      bubbles: row.bubbles,
                      selectedAnswer: row.selected,
                      trueAnswer: answer,
                      onUpdate: (i) {
                        setState(() {
                          final row = RowBubbles(
                            bubbles: answers.rows[index].bubbles,
                            selected: answers.rows[index].selected == i ? null : i,
                          );
                          //
                          final rows = answers.rows;
                          //
                          rows[index] = row;
                          //
                          answers = AnswersData(rows: rows);
                        });
                      },
                    );
                  },
                ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget idBuilder({required IdData id}) {
    return Center(
      child: SizedBox(
        width: SpacingResources.mainWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            7,
            (index) {
              return Expanded(
                child: IDColumnWidget(
                  bubbles: id.rows[index].bubbles,
                  selectedBubble: id.rows[index].selected,
                  onUpdate: (i) {
                    setState(() {
                      final row = RowBubbles(
                        bubbles: id.rows[index].bubbles,
                        selected: id.rows[index].selected == i ? null : i,
                      );
                      // //
                      final rows = id.rows;
                      // //
                      rows[index] = row;
                      // //
                      id = IdData(rows: rows);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
