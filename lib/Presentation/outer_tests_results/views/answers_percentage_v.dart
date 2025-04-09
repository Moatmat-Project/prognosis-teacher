import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/test_details.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/answer.dart';
import 'package:moatmat_teacher/Presentation/export/views/questions/export_questions_v.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/answer_body_w.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/question_item_widget.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';

class OuterTestAnswersPercentage extends StatefulWidget {
  const OuterTestAnswersPercentage({
    super.key,
    required this.details,
    required this.test,
  });
  final RepositoryDetails details;
  final OuterTest test;

  @override
  State<OuterTestAnswersPercentage> createState() => _OuterTestAnswersPercentageState();
}

class _OuterTestAnswersPercentageState extends State<OuterTestAnswersPercentage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نسب اختيار الأجوبة"),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.test.forms.first.questions.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      QuestionItemWidget(question: widget.test.forms.first.questions[index].toQuestion()),
                      ...List.generate(
                        5,
                        (i) {
                          final p = widget.details.selectionPercents[index][i];

                          return Container(
                            width: SpacingResources.mainWidth(context),
                            margin: const EdgeInsets.symmetric(
                              vertical: SpacingResources.sidePadding / 2,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsResources.onPrimary,
                              border: Border.all(
                                color: ColorsResources.onPrimary,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                AnswerBodyWidget(
                                  answer: Answer(
                                    id: 0,
                                    text: numberToLetter(i + 1),
                                    equations: [],
                                    trueAnswer: widget.test.forms.first.questions[index].trueAnswer == i,
                                    image: "",
                                  ),
                                ),
                                const SizedBox(height: SizesResources.s2),
                                Text("%${(p * 100).toStringAsFixed(1)}")
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: SizesResources.s8),
            child: SizedBox(
              width: SpacingResources.mainWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButtonWidget(
                    text: "السابق",
                    width: SpacingResources.mainHalfWidth(context),
                    onPressed: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  const Spacer(),
                  ElevatedButtonWidget(
                    text: "التالي",
                    width: SpacingResources.mainHalfWidth(context),
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String func(int index) {
    return String.fromCharCode(65 + index); // ASCII value of 'A' is 65
  }
}
