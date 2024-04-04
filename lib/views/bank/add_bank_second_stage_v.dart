import 'package:flutter/material.dart';
import 'package:moatmat_teacher/classes/bank/bank.dart';
import 'package:moatmat_teacher/classes/bank/bank_q.dart';
import 'package:moatmat_teacher/views/bank/add_bank_question_v.dart';
import 'package:moatmat_teacher/views/bank/add_bank_third_stage_v.dart';

class AddBankSecondStageView extends StatefulWidget {
  const AddBankSecondStageView({super.key, required this.bank});
  final Bank bank;
  @override
  State<AddBankSecondStageView> createState() => _AddBankSecondStageViewState();
}

class _AddBankSecondStageViewState extends State<AddBankSecondStageView> {
  List<BankQuestion> questions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: AddBankQuestionView(
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
                  builder: (c) => AddBankThirdStageView(
                    bank: widget.bank.copyWith(questions: questions),
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
