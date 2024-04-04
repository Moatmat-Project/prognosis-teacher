import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moatmat_teacher/classes/test/answer.dart';
import 'package:moatmat_teacher/classes/test/question.dart';

import '../../widgets/checking_w.dart';
import '../../widgets/text_field_w.dart';

class AddTestQuestionView extends StatefulWidget {
  const AddTestQuestionView({super.key, required this.onAdd});
  final Function(TestQuestion question) onAdd;
  @override
  State<AddTestQuestionView> createState() => _AddTestQuestionViewState();
}

class _AddTestQuestionViewState extends State<AddTestQuestionView> {
  TestQuestion question = TestQuestion(
    id: 0,
    question: "",
    explain: "",
    equation: "",
    image: null,
    time: null,
    editable: false,
    answers: [],
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            TextFieldWidget(
              hint: "السؤال",
              onChanged: (p0) {
                question = question.copyWith(question: p0);
              },
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: 100,
              minLines: 1,
            ),
            TextFieldWidget(
              hint: "شرح الاجابة (يمكن تركه فارغ)",
              onChanged: (p0) {
                question = question.copyWith(explain: p0);
              },
            ),
            TextFieldWidget(
              hint: "وقت مخصص للسؤال",
              onChanged: (p0) {
                question = question.copyWith(time: int.tryParse(p0));
              },
            ),
            TextFieldWidget(
              hint: "معادلة (يمكن تركه فارغ)",
              onChanged: (p0) {
                question = question.copyWith(equation: p0);
              },
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: 100,
              minLines: 1,
            ),
            CheckingWidget(
              title: "تمكين تعديل الاجابة",
              onChanged: (p0) {
                setState(() {
                  question = question.copyWith(editable: p0);
                });
              },
              value: question.editable,
            ),
            TextButton(
              onPressed: () async {
                var res = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                setState(() {
                  question = question.copyWith(image: res?.path);
                });
              },
              child:
                  Text(question.image != null ? "تغيير الصورة" : "اضافة صورة"),
            ),
            TestAnswersBuilderWidget(
              onChange: (answers) {
                question = question.copyWith(answers: answers);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                widget.onAdd(question);
                Navigator.of(context).pop();
              },
              child: const Text(
                "اضافة",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class TestAnswersBuilderWidget extends StatefulWidget {
  const TestAnswersBuilderWidget({super.key, required this.onChange});
  final Function(List<TestAnswer> answers) onChange;
  @override
  State<TestAnswersBuilderWidget> createState() =>
      _TestAnswersBuilderWidgetState();
}

class _TestAnswersBuilderWidgetState extends State<TestAnswersBuilderWidget> {
  List<TestAnswer> answers = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: answers.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                TextFieldWidget(
                  hint: "نص الاجابة",
                  initialValue: answers[index].answer,
                  onChanged: (p0) {
                    answers[index] = answers[index].copyWith(answer: p0);
                    widget.onChange(answers);
                  },
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 100,
                  minLines: 1,
                ),
                TextFieldWidget(
                  hint: "المعادلة",
                  initialValue: answers[index].equation,
                  onChanged: (p0) {
                    answers[index] = answers[index].copyWith(equation: p0);
                    widget.onChange(answers);
                  },
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 100,
                  minLines: 1,
                ),
                CheckingWidget(
                  title: "اجابة صحيحة",
                  onChanged: (p0) {
                    setState(() {
                      answers[index] = answers[index].copyWith(isCorrect: p0);
                      widget.onChange(answers);
                    });
                  },
                  value: answers[index].isCorrect,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      answers.removeAt(index).answer;
                      widget.onChange(answers);
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              answers.add(TestAnswer(
                answer: "",
                equation: "",
                isCorrect: false,
              ));
            });
          },
          icon: const Icon(
            Icons.add_circle_outline_sharp,
          ),
        ),
      ],
    );
  }
}
