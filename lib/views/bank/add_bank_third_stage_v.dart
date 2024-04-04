import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/classes/bank/b_question_answer.dart';
import 'package:moatmat_teacher/classes/bank/bank.dart';
import 'package:moatmat_teacher/classes/bank/bank_q.dart';
import 'package:moatmat_teacher/classes/test/test.dart';
import 'package:moatmat_teacher/models/bank/bank_m.dart';
import 'package:moatmat_teacher/models/test/test_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBankThirdStageView extends StatefulWidget {
  const AddBankThirdStageView({super.key, required this.bank});
  final Bank bank;
  @override
  State<AddBankThirdStageView> createState() => _AddBankThirdStageViewState();
}

class _AddBankThirdStageViewState extends State<AddBankThirdStageView> {
  Future<int> insertTest() async {
    List<BankQuestion> questions = [];

    try {
      for (var question in widget.bank.questions) {
        if (question.image != null) {
          questions.add(
            question.copyWith(
              image: await uploadFileAndGetUrl(
                widget.bank,
                question.image!,
              ),
            ),
          );
        } else {
          questions.add(question);
        }
      }

      await Supabase.instance.client.from("banks").insert(
            BankModel.fromClass(widget.bank.copyWith(questions: questions))
                .toJson(),
          );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      print(e);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("رفع الاختبار"),
      ),
      body: FutureBuilder<int>(
        future: insertTest(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(child: Text("تمت اضافة الاختبار بنجاح"));
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}

Future<String> uploadFileAndGetUrl(Bank bank, String name) async {
  //
  var file = File(name);
  //
  name = name.split("/").last;
  //
  String path = "${bank.id}/$name";

  //
  try {
    await Supabase.instance.client.storage.from("banks").upload(path, file);
  } on Exception catch (e) {
    print(e);
  }
  //
  late String publicUrl;
  publicUrl = Supabase.instance.client.storage.from('banks').getPublicUrl(path);
  return publicUrl;
}
