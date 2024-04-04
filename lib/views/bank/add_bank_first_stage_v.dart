import 'package:flutter/material.dart';
import 'package:moatmat_teacher/classes/bank/bank.dart';
import 'package:moatmat_teacher/views/bank/add_bank_second_stage_v.dart';

import '../../widgets/text_field_w.dart';

class AddBankFirstStageView extends StatefulWidget {
  const AddBankFirstStageView({super.key});

  @override
  State<AddBankFirstStageView> createState() => _AddBankFirstStageViewState();
}

class _AddBankFirstStageViewState extends State<AddBankFirstStageView> {
  Bank bank = Bank(
    id: 0,
    cost: 0,
    title: "",
    clas: "",
    material: "",
    teacher: "",
    questions: [],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحديد معلومات البنك"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFieldWidget(
              hint: "عنوان البنك",
              onChanged: (t) {
                bank = bank.copyWith(title: t);
              },
            ),
            TextFieldWidget(
              hint: "الصف",
              onChanged: (t) {
                bank = bank.copyWith(clas: t);
              },
            ),
            TextFieldWidget(
              hint: "المادة",
              onChanged: (t) {
                bank = bank.copyWith(material: t);
              },
            ),
            TextFieldWidget(
              hint: "الاستاذ",
              onChanged: (t) {
                bank = bank.copyWith(teacher: t);
              },
            ),
            TextFieldWidget(
              hint: "التكلفة (يمكن تركة فارغ)",
              onChanged: (t) {
                bank = bank.copyWith(cost: int.tryParse(t));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => AddBankSecondStageView(bank: bank),
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
