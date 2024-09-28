import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/services/questions_cash_s.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Presentation/banks/state/add_bank/add_bank_cubit.dart';
import 'package:moatmat_teacher/Presentation/picker/views/questions_picker_v_manager.dart';

import '../../../Presentation/questions/widgets/question_item_widget.dart';
import '../../../Presentation/tests/state/add_test/add_test_cubit.dart';
import '../../resources/sizes_resources.dart';
import '../fields/elevated_button_widget.dart';

class SetQuestionsView extends StatefulWidget {
  //
  const SetQuestionsView({
    super.key,
    required this.questions,
    required this.onOpenQuestion,
    required this.onDeleteQuestion,
    required this.onAddQuestion,
    required this.onFinish,
    this.isBank = false,
    required this.onBack,
  });
  //
  final List<Question> questions;
  final Function(Question question, int index) onOpenQuestion;
  final Function(int index) onDeleteQuestion;
  final VoidCallback onAddQuestion;
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final bool isBank;
  //
  @override
  State<SetQuestionsView> createState() => _SetQuestionsViewState();
}

class _SetQuestionsViewState extends State<SetQuestionsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((e) {
      if (QuestionsCashS.canLoadQuestions(widget.isBank ? "bank" : "test")) {
        showAlert(
          context: context,
          title: "استعادة الكاش",
          body: "هل ترغب باستعادة اخر اسئلة قمت بأنشاءها سابقا؟",
          onAgree: () {
            if (widget.isBank) {
              context.read<AddBankCubit>().loadQuestions();
            } else {
              context.read<AddTestCubit>().loadQuestions();
            }
          },
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: widget.isBank
            ? const Text(
                "اعداد اسئلة البنك",
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            : const Text(
                "اعداد اسئلة الاختبار",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                side: const BorderSide(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionsPickerViewsManager(
                      result: (questions) {
                        for (var q in questions) {
                          if (widget.isBank) {
                            context.read<AddBankCubit>().setBankQuestions(
                                  question: q,
                                );
                          } else {
                            context.read<AddTestCubit>().setTestQuestions(
                                  question: q,
                                );
                          }
                        }
                      },
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  "أستيراد اسئلة",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: ColorsResources.whiteText1,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuestionItemWidget(
                question: widget.questions[index],
                onTap: () {
                  widget.onOpenQuestion(widget.questions[index], index);
                  setState(() {});
                },
                onDelete: () {
                  widget.onDeleteQuestion(index);
                  setState(() {});
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorsResources.primary,
        onPressed: () {
          widget.onAddQuestion();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "حفظ و انهاء",
          onPressed: widget.questions.isEmpty
              ? null
              : () async {
                  widget.onFinish();
                },
        ),
      ),
    );
  }
}
