import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/math/calculate_mark_f.dart';
import 'package:moatmat_teacher/Core/functions/math/mark_to_latter_f.dart';
import 'package:moatmat_teacher/Core/functions/parsers/date_to_text_f.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/fonts_r.dart';
import 'package:moatmat_teacher/Core/resources/shadows_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Core/widgets/ui/divider_w.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_question.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/answer.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Presentation/export/views/questions/export_questions_v.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/answer_item_widget.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/question_item_widget.dart';
import 'package:moatmat_teacher/Presentation/students/state/student/student_cubit.dart';

import '../../../Core/functions/parsers/period_to_text_f.dart';
import '../../../Core/functions/parsers/time_to_text_f.dart';
import '../../../Features/outer_tests/domain/entities/outer_test.dart';
import '../../../Features/students/domain/entities/result.dart';
import '../../../Features/students/domain/entities/user_data.dart';
import '../../../Features/tests/domain/entities/test/test.dart';

class StudentResultDetailsView extends StatefulWidget {
  const StudentResultDetailsView({
    super.key,
    required this.test,
    required this.bank,
    required this.testAverage,
    required this.wrongAnswers,
    required this.result,
    required this.userData,
    this.outerTest,
  });
  final Test? test;
  final Bank? bank;
  final OuterTest? outerTest;
  final double? testAverage;
  final List<(Question?, int?)> wrongAnswers;
  final Result result;
  final UserData userData;

  @override
  State<StudentResultDetailsView> createState() => _StudentResultDetailsViewState();
}

class _StudentResultDetailsViewState extends State<StudentResultDetailsView> {
  int? id;
  List<Question> questions = [];
  @override
  void initState() {
    if (widget.test != null) {
      id = widget.test!.id;
      questions = widget.test!.questions;
    }
    if (widget.bank != null) {
      id = widget.bank!.id;
      questions = widget.bank!.questions;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<StudentCubit>().pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text("تفاصيل النتيجة"),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showAlert(
                context: context,
                title: "تاكيد الحذف",
                body: "هل انت متاكد من انك تريد حذف نتيجة الطالب؟",
                onAgree: () {
                  context.read<StudentCubit>().deleteResult(
                    [widget.result.id],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 18,
            ),
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoItemWidget(
                  t1: "الاسم",
                  t2: widget.userData.name,
                ),
                //
                InfoItemWidget(
                  t1: "العلامة",
                  t2: getMark(),
                ),
              ],
            ),
            //
            if (widget.testAverage != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoItemWidget(
                    t1: "المعدل العام",
                    t2: "%${widget.testAverage!.toStringAsFixed(2)}",
                  ),

                  //
                  InfoItemWidget(
                    t1: "التصنيف",
                    t2: (markToLatterFunction(calculateMarkFunction(
                      widget.result,
                      questions,
                    ))),
                  ),
                ],
              ),
            //
            if (widget.testAverage != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoItemWidget(
                    t1: "تاريخ الحل",
                    t2: dateToTextFunction(widget.result.date),
                  ),
                  //
                  InfoItemWidget(
                    t1: "وقت الحل",
                    t2: timeToText(widget.result.date),
                  ),
                ],
              ),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.outerTest == null)
                  InfoItemWidget(
                    t1: "مدة الحل",
                    t2: periodToTextFunction(widget.result.period),
                  ),
                (id != null)
                    ? InfoItemWidget(
                        t1: "رقم الاختبار",
                        t2: id.toString(),
                      )
                    : SizedBox(
                        width: SpacingResources.mainHalfWidth(context),
                      ),
              ],
            ),

            //
            const SizedBox(height: SizesResources.s4),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: SpacingResources.mainWidth(context),
                  child: const Row(
                    children: [
                      Text("الإجابات الخاطئة :"),
                    ],
                  ),
                ),
              ],
            ),
            //
            if (widget.wrongAnswers.isNotEmpty && widget.wrongAnswers.first.$1 != null && widget.outerTest == null)
              NormalWrongAnswersBuilder(
                wrongAnswers: widget.wrongAnswers.map((e) => (e.$1!, e.$2)).toList(),
              ),
            if (widget.wrongAnswers.isNotEmpty && widget.outerTest != null)
              OuterWrongAnswersBuilder(
                questions: widget.outerTest!.forms[widget.result.form! < widget.outerTest!.forms.length ? widget.result.form! : 0].questions,
                answers: widget.result.answers,
              ),
            //
            const SizedBox(height: SizesResources.s2),
            //
          ],
        ),
      ),
    );
  }

  String getMark() {
    if (widget.result.outerTestId != null) {
      int count = 0;
      List<int?> answers = widget.result.answers;
      List<int> trueAnswers = widget.outerTest!.forms[widget.result.form! < widget.outerTest!.forms.length ? widget.result.form! : 0].questions.map((e) => e.trueAnswer).toList();

      for (int i = 0; i < widget.outerTest!.forms.first.questions.length; i++) {
        if (answers[i] == (trueAnswers[i] + 1)) {
          count++;
        }
      }
      return "${((count / trueAnswers.length) * 100).toStringAsFixed(2)}%";
    }
    if (widget.result.bankId == null) {
      if (widget.result.testId == null) {
        return widget.result.mark.toString();
      }
    }

    return "%${(
      calculateMarkFunction(
            widget.result,
            questions,
          ) *
          100,
    )}";
  }
}

class InfoItemWidget extends StatelessWidget {
  const InfoItemWidget({
    super.key,
    required this.t1,
    required this.t2,
    this.w1,
    this.w2,
  });
  final String? t1, t2;
  final Widget? w1, w2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainHalfWidth(context),
          height: SpacingResources.mainHalfWidth(context) / 2,
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SizesResources.s3,
            vertical: SizesResources.s3,
          ),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: ShadowsResources.mainBoxShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //
              if (w1 != null) w1!,
              if (t1 != null)
                Text(
                  t1!,
                  textAlign: TextAlign.center,
                  style: FontsResources.styleMedium(
                    size: 12,
                  ),
                ),
              //
              const SizedBox(height: SizesResources.s2),
              //
              if (t2 != null)
                Text(
                  t2!,
                  textAlign: TextAlign.center,
                  style: FontsResources.styleRegular(
                    size: 14,
                    color: ColorsResources.darkPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              if (w2 != null) w2!,
            ],
          ),
        ),
      ],
    );
  }
}

class NormalWrongAnswersBuilder extends StatelessWidget {
  const NormalWrongAnswersBuilder({super.key, required this.wrongAnswers});
  final List<(Question, int?)> wrongAnswers;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      //
      itemCount: wrongAnswers.length,
      separatorBuilder: (context, index) {
        return const DividerWidget();
      },
      //
      itemBuilder: (context, i) {
        //
        Question? question = wrongAnswers[i].$1;
        //
        Answer? answer;
        //
        if (wrongAnswers[i].$2 != null) {
          answer = question.answers[wrongAnswers[i].$2!];
        }
        //

        return Column(
          children: [
            QuestionItemWidget(question: question),
            ...List.generate(
              question.answers.length,
              (i) {
                return AnswerItemWidget(
                  answer: question.answers[i],
                  selected: question.answers[i].id == answer?.id,
                );
              },
            ),
            if (answer == null)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "لم يتم الاجابة",
                  style: TextStyle(
                    color: ColorsResources.red,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}

class OuterWrongAnswersBuilder extends StatelessWidget {
  ///
  const OuterWrongAnswersBuilder({
    super.key,
    required this.answers,
    required this.questions,
  });

  ///
  final List<OuterQuestion> questions;
  final List<int?> answers;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 15),
      itemCount: questions.length,
      //
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      //
      itemBuilder: (context, index) {
        //
        int? selection = answers[index];
        OuterQuestion question = questions[index];
        //
        if ((selection) == (question.trueAnswer + 1)) {
          return const SizedBox();
        }
        if (1 == 1) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: SizedBox(
                  width: SpacingResources.mainWidth(context),
                  height: (SpacingResources.mainWidth(context)) / 6,
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: ColorsResources.whiteText1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: ColorsResources.blackText1,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(
                      5,
                      (i) {
                        bool trueAnswer = questions[index].trueAnswer == i;
                        Color color1 = ColorsResources.red;
                        return Expanded(
                          child: CircleAvatar(
                            backgroundColor: ((selection ?? 1) - 1) == i
                                ? color1
                                : trueAnswer
                                    ? Colors.green
                                    : null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                numberToLetter(i + 1),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
              ),
            ],
          );
        }
        return TouchableTileWidget(
          title: "رقم السؤال : ${index + 1}",
          subTitle: getSubTitle(selection),
          icon: Icon(
            selection == null ? Icons.question_mark : Icons.close,
            color: selection == null ? Colors.orange : Colors.red,
          ),
        );
      },
    );
  }

  getSubTitle(int? selection) {
    return selection == null ? "لم يتم الاختيار" : "تم اختيار  ${numberToLetter(selection)}";
  }
}
