import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/attachment_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/checking_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Core/widgets/ui/divider_w.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/answer.dart';
import 'package:moatmat_teacher/Presentation/equations/view/insert_equation_v.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/answer_body_w.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';

class CreateAnswerView extends StatefulWidget {
  const CreateAnswerView({
    super.key,
    this.answer,
    required this.result,
  });
  final Answer? answer;
  final Function(Answer) result;
  @override
  State<CreateAnswerView> createState() => _CreateAnswerViewState();
}

class _CreateAnswerViewState extends State<CreateAnswerView> {
  late Answer answer;
  late TextEditingController controller;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    //
    controller = TextEditingController(text: widget.answer?.text);
    //
    if (widget.answer != null) {
      answer = widget.answer!;
    } else {
      answer = Answer(
        id: 0,
        text: null,
        image: null,
        trueAnswer: false,
        equations: [],
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "اجابة جديدة",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ColorsResources.blackText1,
            fontSize: 19,
          ),
        ),
        actions: [
          TextButton(
            onPressed: answer.isNotEmpty()
                ? () {
                    if (formKey.currentState?.validate() ?? false) {
                      widget.result(answer);
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            child: widget.answer != null ? const Text("تحديث") : const Text("إضافة"),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              AnswerPreviewWidget(answer: answer),
              //
              const SizedBox(height: SizesResources.s4),
              //
              MyTextFormFieldWidget(
                hintText: "الاجابة",
                minLines: 1,
                maxLines: 10,
                controller: controller,
                onChanged: (p0) {
                  answer = answer.copyWith(text: p0);
                  setState(() {});
                },
              ),
              const SizedBox(height: SizesResources.s2),
              CheckingWidget(
                title: "أجابة صحيحة",
                color: ColorsResources.green,
                value: widget.answer?.trueAnswer ?? answer.trueAnswer,
                onChanged: (v) {
                  answer = answer.copyWith(trueAnswer: v);
                  setState(() {});
                },
              ),
              //
              const DividerWidget(),
              //
              TouchableTileWidget(
                title: "ارفاق معادلات لنص السؤال",
                icon: Image.asset(
                  "assets/other/function.png",
                  width: 20,
                  color: ColorsResources.primary,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InsertEquationView(
                        text: answer.text ?? "",
                        equations: answer.equations ?? [],
                        result: (equations, text) {
                          setState(() {
                            answer = answer.copyWith(
                              equations: equations,
                              text: text,
                            );
                            controller.text = text;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              //
              const DividerWidget(),
              //
              AttachmentWidget(
                title: "ارفاق صورة",
                file: widget.answer?.image ?? answer.image,
                fileType: FileType.image,
                afterPick: (v) {
                  answer = answer.copyWith(image: v);
                  setState(() {});
                },
                onDelete: () {
                  answer = answer.copyWith(image: "");
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnswerPreviewWidget extends StatelessWidget {
  const AnswerPreviewWidget({
    super.key,
    required this.answer,
  });

  final Answer answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainWidth(context),
      margin: const EdgeInsets.symmetric(
        vertical: SpacingResources.sidePadding / 2,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: SpacingResources.sidePadding * 2,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        border: Border.all(color: ColorsResources.borders),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnswerBodyWidget(answer: answer),
    );
  }
}
