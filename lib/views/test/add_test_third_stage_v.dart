import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/classes/test/question.dart';
import 'package:moatmat_teacher/classes/test/test.dart';
import 'package:moatmat_teacher/models/test/test_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTestThirdStageView extends StatefulWidget {
  const AddTestThirdStageView({super.key, required this.test});
  final Test test;
  @override
  State<AddTestThirdStageView> createState() => _AddTestThirdStageViewState();
}

class _AddTestThirdStageViewState extends State<AddTestThirdStageView> {
  List<TestQuestion> questions = [];
  Future<int> insertTest() async {
    try {
      for (var question in widget.test.questions) {
        if (question.image != null) {
          questions.add(
            question.copyWith(
              image: await uploadFileAndGetUrl(
                widget.test,
                question.image!,
              ),
            ),
          );
          print(questions.first.image);
        } else {
          questions.add(question);
        }
      }
      await Supabase.instance.client.from("tests").insert(
          TestModel.fromClass(widget.test.copyWith(questions: questions))
              .toJson());
      return 0;
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      print(e);
      throw Exception();
    }
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

Future<String> uploadFileAndGetUrl(Test test, String name) async {
  //
  var file = File(name);
  //
  name = name.split("/").last;
  //
  String path = "${test.id}/$name";

  //
  try {
    await Supabase.instance.client.storage.from("tests").upload(path, file);
  } on StorageException {}
  //
  late String publicUrl;
  publicUrl = Supabase.instance.client.storage.from('tests').getPublicUrl(path);
  return publicUrl;
}
