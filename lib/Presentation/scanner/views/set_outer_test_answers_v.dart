import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_question.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test_form.dart';
import 'package:moatmat_teacher/Presentation/export/views/questions/export_questions_v.dart';
import 'package:moatmat_teacher/Presentation/tests/state/add_outer_test/add_outer_test_cubit.dart';

import '../../../Features/outer_tests/data/models/outer_question.dart';

class SetOuterTestAnswersView extends StatefulWidget {
  const SetOuterTestAnswersView({super.key, required this.forms, required this.onSetForms});
  final List<OuterTestForm> forms;
  final void Function(List<OuterTestForm> form) onSetForms;
  @override
  State<SetOuterTestAnswersView> createState() => _SetOuterTestAnswersViewState();
}

class _SetOuterTestAnswersViewState extends State<SetOuterTestAnswersView> {
  late List<OuterTestForm> forms;

  @override
  void initState() {
    super.initState();
    forms = List.from(widget.forms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.read<AddOuterTestCubit>().back(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Directionality(
          textDirection: TextDirection.ltr,
          child: PageView.builder(
            itemCount: forms.length,
            itemBuilder: (context, formIndex) {
              return Column(
                children: [
                  const SizedBox(height: SizesResources.s1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("النموذج ${numberToLetter(forms[formIndex].id + 1)}"),
                    ],
                  ),
                  const SizedBox(height: SizesResources.s1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: forms[formIndex].questions.length,
                      itemBuilder: (context, questionIndex) {
                        final OuterQuestion question = forms[formIndex].questions[questionIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: SizesResources.s2,
                            horizontal: SizesResources.s2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "${question.id + 1} - ",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //
                              ...List.generate(5, (i) {
                                bool selected = question.trueAnswer == i;
                                Color color1 = ColorsResources.primary;
                                Color color2 = ColorsResources.whiteText1;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final newQuestion = question.copyWith(
                                          trueAnswer: i,
                                        );
                                        (forms[formIndex].questions)[questionIndex] = OuterQuestionModel.fromClass(newQuestion);
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: selected ? color1 : null,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          numberToLetter(i + 1),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: selected ? color2 : null,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s5),
        child: ElevatedButtonWidget(
          text: "حفظ",
          onPressed: () {
            widget.onSetForms(forms);
          },
        ),
      ),
    );
  }
}
