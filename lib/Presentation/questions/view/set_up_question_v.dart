import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/widgets/fields/checking_w.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Presentation/questions/state/cubit/create_question_cubit.dart';
import 'package:moatmat_teacher/Presentation/questions/view/edit_colors_v.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/question_body_w.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/ui/divider_w.dart';
import '../../../Features/tests/domain/entities/question/answer.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/attachment_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Presentation/equations/view/insert_equation_v.dart';

class SetUpQuestionView extends StatefulWidget {
  const SetUpQuestionView({super.key, required this.question});
  final Question question;
  @override
  State<SetUpQuestionView> createState() => _SetUpQuestionViewState();
}

class _SetUpQuestionViewState extends State<SetUpQuestionView> {
  late Question question;
  late List<Answer> answers;
  late List<String> equations;
  //
  late TextEditingController explainTextController;
  late TextEditingController upperImageTextController;
  late TextEditingController lowerImageTextController;
  //
  @override
  void initState() {
    //
    answers = widget.question.answers;
    equations = widget.question.equations;
    //
    question = widget.question;
    //
    explainTextController = TextEditingController(
      text: widget.question.explain,
    );
    upperImageTextController = TextEditingController(
      text: widget.question.upperImageText,
    );
    lowerImageTextController = TextEditingController(
      text: widget.question.lowerImageText,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateQuestionCubit>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: question.isNotEmpty()
            ? const Text(
                "تعديل السؤال",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorsResources.blackText1,
                  fontSize: 22,
                ),
              )
            : const Text(
                "سؤال جديد",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorsResources.blackText1,
                  fontSize: 22,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            QuestionPreviewWidget(question: question),
            //
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "السؤال",
              minLines: 1,
              maxLines: 10,
              controller: lowerImageTextController,
              suffix: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditColorsView(
                      text: question.lowerImageText ?? "",
                      colors: question.colors,
                      result: (p0) {
                        question = question.copyWith(colors: p0);
                        bloc.updateQuestion(question);
                      },
                    ),
                  ));
                },
                icon: const Icon(Icons.color_lens),
              ),
              onChanged: (p0) {
                question = question.copyWith(lowerImageText: p0);
                bloc.updateQuestion(question);
              },
            ),
            //
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "شرح السؤال",
              controller: explainTextController,
              minLines: 1,
              maxLines: 10,
              onChanged: (p0) {
                question = question.copyWith(explain: p0);
                bloc.updateQuestion(question);
              },
            ),
            //
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "وقت مخصص للسؤال (بالثواني)",
              initialValue: (widget.question.period ?? "").toString(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (p0) {
                if (p0 != null && p0 != "") {
                  question = question.copyWith(period: int.tryParse(p0));
                  bloc.updateQuestion(question);
                }
              },
            ),
            const SizedBox(height: SizesResources.s2),
            //
            CheckingWidget(
              title: "يمكن تعديل الاجابة",
              value: question.editable,
              onChanged: (b) {
                question = question.copyWith(editable: b);
                bloc.updateQuestion(question);
              },
            ),
            //
            const DividerWidget(),
            //
            AttachmentWidget(
              title: "ارفاق معادلات لنص الشرح",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InsertEquationView(
                      text: question.explain ?? "",
                      result: (equations, text) {
                        setState(() {
                          //
                          question = question.copyWith(
                            explain: text,
                            equations: equations,
                          );
                          //
                          this.equations = equations;
                          //
                          explainTextController.text = question.explain ?? "";
                          //
                          context.read<CreateQuestionCubit>().updateQuestion(
                                question,
                              );
                        });
                      },
                      equations: equations,
                    ),
                  ),
                );
              },
              onDelete: () {},
              afterPick: (v) {},
            ),
            //
            AttachmentWidget(
              title: "ارفاق معادلات لنص السؤال",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InsertEquationView(
                      text: question.lowerImageText ?? "",
                      result: (equations, text) {
                        setState(() {
                          //
                          question = question.copyWith(
                            lowerImageText: text,
                            equations: equations,
                          );
                          //
                          this.equations = equations;
                          //
                          lowerImageTextController.text = question.lowerImageText ?? "";
                          //
                          context.read<CreateQuestionCubit>().updateQuestion(
                                question,
                              );
                        });
                      },
                      equations: equations,
                    ),
                  ),
                );
              },
              onDelete: () {},
              afterPick: (v) {},
            ),
            //

            AttachmentWidget(
              title: "ارفاق معادلات للنص قبل الصورة",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InsertEquationView(
                      text: question.upperImageText ?? "",
                      result: (equations, text) {
                        setState(() {
                          //
                          question = question.copyWith(
                            upperImageText: text,
                            equations: equations,
                          );
                          //
                          this.equations = equations;
                          //
                          upperImageTextController.text = question.upperImageText ?? "";
                          //
                          context.read<CreateQuestionCubit>().updateQuestion(
                                question,
                              );
                        });
                      },
                      equations: equations,
                    ),
                  ),
                );
              },
              onDelete: () {},
              afterPick: (v) {},
            ),

            //
            const DividerWidget(),
            //
            AttachmentWidget(
              title: "ارفاق صورة للسؤال",
              fileType: FileType.image,
              file: widget.question.image,
              afterPick: (p0) {
                question = question.copyWith(image: p0);
                bloc.updateQuestion(question);
              },
              onDelete: () {
                question = question.copyWith(image: "");

                bloc.updateQuestion(question);
              },
            ),
            //
            const SizedBox(height: SizesResources.s2),
            //
            AttachmentWidget(
              title: "ارفاق صورة لشرح السؤال",
              fileType: FileType.image,
              file: widget.question.explainImage,
              afterPick: (p0) {
                question = question.copyWith(explainImage: p0);
                bloc.updateQuestion(question);
              },
              onDelete: () {
                question = question.copyWith(explainImage: "");

                bloc.updateQuestion(question);
              },
            ),
            //
            const SizedBox(height: SizesResources.s2),
            MyTextFormFieldWidget(
              hintText: "نص قبل الصورة",
              controller: upperImageTextController,
              onChanged: (p0) {
                question = question.copyWith(upperImageText: p0);
                bloc.updateQuestion(question);
              },
            ),
            //
            const DividerWidget(),
            //
            AttachmentWidget(
              title: "ارفاق فيديو لشرح السؤال",
              fileType: FileType.any,
              file: widget.question.video,
              afterPick: (p0) {
                question = question.copyWith(video: p0);
                bloc.updateQuestion(question);
              },
              onDelete: () {
                question = question.copyWith(video: "");
                bloc.updateQuestion(question);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "التالي",
          onPressed: question.isNotEmpty()
              ? () async {
                  bloc.emitSetUpAnswers();
                }
              : null,
        ),
      ),
    );
  }
}

class QuestionPreviewWidget extends StatelessWidget {
  const QuestionPreviewWidget({
    super.key,
    required this.question,
  });

  final Question question;

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
      child: QuestionBodyWidget(question: question),
    );
  }
}
