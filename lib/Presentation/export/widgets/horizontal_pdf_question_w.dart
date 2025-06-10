import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Features/tests/domain/entities/question/question.dart';
import '../../questions/widgets/answer_body_w.dart';
import '../../questions/widgets/question_body_w.dart';
import '../views/questions/export_questions_v.dart';

class HorizontalPDFQuestionWidget extends StatelessWidget {
  const HorizontalPDFQuestionWidget({super.key, required this.id, required this.question, required this.controller});
  final int id;
  final Question question;
  final ScreenshotController controller;
  @override
  Widget build(BuildContext context) {
    bool showImage = (question.image != null && question.image != "");
    bool showUpperText = (question.upperImageText != null && question.upperImageText != "");
    bool showLowerText = (question.lowerImageText != null && question.lowerImageText != "");
    double width = 1800;
    double imgWidth = 600;
    double qNumWidth = 75;
    double qTextWidth = showImage ? (width - qNumWidth) - imgWidth : (width - qNumWidth);
    return Screenshot(
      controller: controller,
      child: Container(
        width: width,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SizesResources.s1_5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: SizedBox(
                        width: qNumWidth,
                        child: Text(
                          "$id - ",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: qTextWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showUpperText) ...[
                            QuestionTextBuilderWidget(
                              fontFamily: "Arial",
                              text: question.upperImageText!,
                              width: qTextWidth,
                              fontWeight: FontWeight.w500,
                              wrapAlignment: WrapAlignment.start,
                              fontSize: 45,
                              mathFontSize: 36,
                              textAlign: TextAlign.center,
                              padding: EdgeInsets.only(bottom: 24, left: 6, right: 6),
                              textPadding: EdgeInsets.only(top: 12),
                              disableNewLines: true,
                              colors: question.colors,
                              equations: question.equations,
                            ),
                          ],
                          const SizedBox(height: SizesResources.s4),
                          //
                          if (showLowerText) ...[
                            QuestionTextBuilderWidget(
                              fontFamily: "Arial",
                              text: question.lowerImageText!,
                              width: qTextWidth,
                              fontWeight: FontWeight.w500,
                              wrapAlignment: WrapAlignment.start,
                              fontSize: 45,
                              mathFontSize: 36,
                              textAlign: TextAlign.center,
                              padding: EdgeInsets.only(bottom: 20),
                              textPadding: EdgeInsets.only(top: 12),
                              disableNewLines: true,
                              colors: question.colors,
                              equations: question.equations,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                //
                if (showImage) ...[
                  SizedBox(
                    width: imgWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QuestionImageBuilderWidget(
                          image: question.image!,
                          width: imgWidth * 0.8,
                          radius: BorderRadius.circular(0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SizesResources.s6),
                ],
              ],
            ),
            const SizedBox(height: SizesResources.s1_5),
            //
            Container(
              width: width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    question.answers.length * 2 - 1,
                    (i) {
                      if (i.isOdd) {
                        return VerticalDivider(
                          width: 1,
                          color: Colors.black,
                          thickness: 1,
                        );
                      }
                      final index = i ~/ 2;
                      final answer = question.answers[index];
                      return SizedBox(
                        width: answerWidth / question.answers.length,
                        child: Row(
                          children: [
                            SizedBox(
                              width: (answerWidth * 0.1) / question.answers.length,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    numberToLetter(index + 1),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 36),
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              color: Colors.black,
                              thickness: 1,
                            ),
                            Column(
                              children: [
                                if (answer.text != null && answer.text != "") ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: QuestionTextBuilderWidget(
                                      fontFamily: "Arial",
                                      width: (answerWidth * 0.8) / question.answers.length,
                                      text: answer.text!,
                                      equations: answer.equations ?? [],
                                      fontSize: 40,
                                      mathFontSize: 35,
                                      fontWeight: FontWeight.w500,
                                      wrapAlignment: WrapAlignment.center,
                                      textAlign: TextAlign.center,
                                      padding: EdgeInsets.only(bottom: 15, left: 2, right: 2),
                                      textPadding: EdgeInsets.only(top: 4),
                                      colors: const [],
                                    ),
                                  ),
                                ],
                                if (answer.image != null && answer.image != "") ...[
                                  AnswerImageBuilderWidget(
                                    image: answer.image!,
                                    width: (answerWidth * 0.75) / question.answers.length,
                                    fit: BoxFit.fitWidth,
                                    radius: BorderRadius.circular(0),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: SizesResources.s1_5),
            //
          ],
        ),
      ),
    );
  }

  int get answerWidth {
    int outerBordersOfContainer = 2;
    int innerBordersOfContainer = 10;
    return 1800 - (outerBordersOfContainer + innerBordersOfContainer);
  }
}
