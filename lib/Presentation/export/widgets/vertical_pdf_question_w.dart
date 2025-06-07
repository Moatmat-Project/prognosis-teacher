import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Features/tests/domain/entities/question/question.dart';
import '../../questions/widgets/answer_body_w.dart';
import '../../questions/widgets/question_body_w.dart';
import '../views/questions/export_questions_v.dart';

class VerticalPDFquestionWidget extends StatelessWidget {
  const VerticalPDFquestionWidget({
    super.key,
    required this.id,
    required this.question,
    required this.controller,
  });
  final int id;
  final Question question;
  final ScreenshotController controller;
  @override
  Widget build(BuildContext context) {
    return Screenshot(
        controller: controller,
        child: Container(
          width: 500,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: SizesResources.s4),
              if (question.upperImageText != null && question.upperImageText != "") ...[
                QuestionTextBuilderWidget(
                  fontFamily: "Arial",
                  text: question.upperImageText!,
                  equations: question.equations,
                  width: 500,
                  fontWeight: FontWeight.w800,
                  wrapAlignment: WrapAlignment.start,
                  fontSize: 30,
                  mathFontSize: 28,
                  colors: const [],
                  disableNewLines: true,
                ),
                const SizedBox(height: SizesResources.s6),
              ],
              //
              if (question.image != null && question.image != "") ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QuestionImageBuilderWidget(
                      image: question.image!,
                      width: 350,
                      radius: BorderRadius.circular(0),
                    ),
                  ],
                ),
                const SizedBox(height: SizesResources.s6),
              ],

              //
              if (question.lowerImageText != null && question.lowerImageText != "") ...[
                QuestionTextBuilderWidget(
                  fontFamily: "Arial",
                  text: question.lowerImageText!,
                  equations: question.equations,
                  fontSize: 30,
                  mathFontSize: 28,
                  fontWeight: FontWeight.w800,
                  width: 500,
                  wrapAlignment: WrapAlignment.start,
                  colors: question.colors,
                  disableNewLines: true,
                ),
                const SizedBox(height: SizesResources.s3),
              ],
              //
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  children: List.generate(
                    question.answers.length,
                    (i) {
                      //
                      final answer = question.answers[i];
                      //
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //
                          if (answer.text != null && answer.text != "") ...[
                            const SizedBox(height: SizesResources.s2),
                            QuestionTextBuilderWidget(
                              fontFamily: "Arial",
                              text: "${numberToLetter(i + 1)}- ${answer.text!}",
                              equations: answer.equations ?? [],
                              fontSize: 30,
                              mathFontSize: 28,
                              fontWeight: FontWeight.w600,
                              wrapAlignment: WrapAlignment.start,
                              colors: const [],
                            ),
                          ],
                          //
                          if (answer.image != null && answer.image != "") ...[
                            const SizedBox(height: SizesResources.s2),
                            AnswerImageBuilderWidget(
                              image: answer.image!,
                              width: 200,
                              fit: BoxFit.fitWidth,
                              radius: BorderRadius.circular(0),
                            ),
                            const SizedBox(height: SizesResources.s2),
                          ],
                          //
                        ],
                      );
                    },
                  ),
                ),
              ), //
              const SizedBox(height: SizesResources.s4),
              //
            ],
          ),
        ));
  }

  getSecondNumber(Question q) {
    if (q.upperImageText != null) {
      if (q.upperImageText!.isNotEmpty) {
        return "";
      }
    }
    return id;
  }
}
