import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/reports/domain/entities/reposrt_data.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/answer_item_widget.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/question_box.w.dart';

import '../../banks/views/add_bank_view.dart';
import '../../questions/widgets/answer_body_w.dart';
import '../../questions/widgets/question_item_widget.dart';
import '../../tests/views/add_test_vew.dart';

class ExploreQuestionView extends StatelessWidget {
  const ExploreQuestionView({
    super.key,
    this.test,
    this.bank,
    required this.reportData,
  });
  final Test? test;
  final Bank? bank;
  final ReportData reportData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل السؤال"),
        actions: [
          TextButton(
            onPressed: () {
              if (bank != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AddBankView(bank: bank),
                  ),
                );
              }
              if (test != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AddTestView(test: test),
                  ),
                );
              }
            },
            child: Text("تعديل ${test != null ? "الأختبار" : "البنك"}"),
          ),
        ],
      ),
      body: Center(
        child: Column(children: [
          QuestionBox(
            question: getQuestion(),
          ),
          ...List.generate(
            getQuestion().answers.length,
            (i) {
              return AnswerItemWidget(answer: getQuestion().answers[i]);
            },
          )
        ]),
      ),
    );
  }

  Question getQuestion() {
    if (test != null) {
      return test!.questions[reportData.questionID - 1];
    } else {
      return bank!.questions[reportData.questionID - 1];
    }
  }
}
