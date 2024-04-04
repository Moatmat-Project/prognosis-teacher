import 'package:flutter/material.dart';
import 'package:moatmat_teacher/classes/test/question.dart';
import 'package:moatmat_teacher/classes/test/test.dart';
import 'package:moatmat_teacher/views/test/add_test_question_v.dart';
import 'package:moatmat_teacher/views/test/add_test_third_stage_v.dart';
import 'package:moatmat_teacher/widgets/checking_w.dart';
import 'package:moatmat_teacher/widgets/text_field_w.dart';

class AddTestSecondStageView extends StatefulWidget {
  const AddTestSecondStageView({super.key, required this.test});
  final Test test;
  @override
  State<AddTestSecondStageView> createState() => _AddTestSecondStageViewState();
}

class _AddTestSecondStageViewState extends State<AddTestSecondStageView> {
  List<TestQuestion> questions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: AddTestQuestionView(
                onAdd: (question) => setState(() {
                  questions.add(question);
                }),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("اضافة اسئلة"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => AddTestThirdStageView(
                    test: widget.test.copyWith(questions: questions),
                  ),
                ),
              );
            },
            child: const Text("اضافة"),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(
              "$index - ${questions[index].question}",
              overflow: TextOverflow.fade,
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  questions.removeAt(index);
                });
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ),
      ),
    );
  }
}
