import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/test_details.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/answer_body_w.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/answer_item_widget.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/question_body_w.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/question_item_widget.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';

class TestAnswersPercentage extends StatefulWidget {
  const TestAnswersPercentage({
    super.key,
    required this.details,
    required this.test,
  });
  final RepositoryDetails details;
  final Test test;

  @override
  State<TestAnswersPercentage> createState() => _TestAnswersPercentageState();
}

class _TestAnswersPercentageState extends State<TestAnswersPercentage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نسب اختيار الاجوبة"),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.test.questions.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      QuestionItemWidget(question: widget.test.questions[index]),
                      ...List.generate(
                        widget.test.questions[index].answers.length,
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
                                  answer: widget.test.questions[index].answers[i],
                                ),
                                const SizedBox(height: SizesResources.s2),
                                Text("%${(p * 100).toStringAsFixed(2)}")
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
