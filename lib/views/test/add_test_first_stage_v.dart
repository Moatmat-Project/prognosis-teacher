import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/classes/test/test.dart';
import 'package:moatmat_teacher/views/test/add_test_second_stage_v.dart';

import '../../widgets/checking_w.dart';
import '../../widgets/text_field_w.dart';

class AddTestFirstStageView extends StatefulWidget {
  const AddTestFirstStageView({super.key});

  @override
  State<AddTestFirstStageView> createState() => _AddTestFirstStageViewState();
}

class _AddTestFirstStageViewState extends State<AddTestFirstStageView> {
  Test test = Test(
    id: 0,
    title: "عنوان الاختبار",
    clas: "الصف",
    material: "",
    teacher: "",
    seconds: 60,
    password: null,
    cost: 0,
    timePerQuestion: false,
    explorable: false,
    returnable: false,
    questions: [],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحديد معلومات الاختبار"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFieldWidget(
              hint: "عنوان الاختبار",
              onChanged: (t) {
                test = test.copyWith(title: t);
              },
            ),
            TextFieldWidget(
              hint: "الصف",
              onChanged: (t) {
                test = test.copyWith(clas: t);
              },
            ),
            TextFieldWidget(
              hint: "المادة",
              onChanged: (t) {
                test = test.copyWith(material: t);
              },
            ),
            TextFieldWidget(
              hint: "الاستاذ",
              onChanged: (t) {
                test = test.copyWith(teacher: t);
              },
            ),
            TextFieldWidget(
              hint: "التكلفة (يمكن تركة فارغ)",
              onChanged: (t) {
                test = test.copyWith(cost: int.tryParse(t));
              },
            ),
            TextFieldWidget(
              hint: "الرمز السري (يمكن تركة فارغ)",
              onChanged: (t) {
                test = test.copyWith(password: t);
              },
            ),
            TextFieldWidget(
              hint: "المدة (ثواني)",
              onChanged: (t) {
                test = test.copyWith(seconds: int.tryParse(t));
              },
            ),
            CheckingWidget(
              value: test.timePerQuestion,
              title: "تعيين المدة للسؤال الواحد",
              onChanged: (p0) {
                setState(() {
                  test = test.copyWith(timePerQuestion: p0);
                });
              },
            ),
            CheckingWidget(
              value: test.explorable,
              title: "تمكين تصفح اسئلة الاختبار",
              onChanged: (p0) {
                setState(() {
                  test = test.copyWith(explorable: p0);
                });
              },
            ),
            CheckingWidget(
              value: test.returnable,
              title: "تمكين اعادة الاختبار",
              onChanged: (p0) {
                setState(() {
                  test = test.copyWith(returnable: p0);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => AddTestSecondStageView(test: test),
                    ),
                  );
                },
                child: const Text(
                  "التالي",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
