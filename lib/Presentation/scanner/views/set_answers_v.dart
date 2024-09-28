import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Presentation/export/views/questions/export_questions_v.dart';
import 'package:moatmat_teacher/Presentation/scanner/state/scanner_views_manager_cubit.dart';

class ScannerSetAnswersView extends StatefulWidget {
  const ScannerSetAnswersView({super.key});
  @override
  State<ScannerSetAnswersView> createState() => _ScannerSetAnswersViewState();
}

class _ScannerSetAnswersViewState extends State<ScannerSetAnswersView> {
  List<List<int>> answers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(answers);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // context.read<ScannerViewsManagerCubit>().showSetSettings();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Directionality(
            textDirection: TextDirection.ltr,
            child: PageView.builder(
              itemCount: answers.length,
              itemBuilder: (context, page) {
                return Column(
                  children: [
                    const SizedBox(height: SizesResources.s1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("النموذج ${numberToLetter(page + 1)}"),
                      ],
                    ),
                    const SizedBox(height: SizesResources.s1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: answers[page].length,
                        itemBuilder: (context, index) {
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
                                        "${index + 1} - ",
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
                                  bool selected = answers[page][index] == i;
                                  Color color1 = ColorsResources.primary;
                                  Color color2 = ColorsResources.whiteText1;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          answers[page][index] = i;
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
            text: "متابعة",
            onPressed: () {
              //
              final cubit = context.read<ScannerViewsManagerCubit>();
              //
              cubit.setAnswers(answers);
              //
              cubit.showPapers();
            },
          ),
        ),
      ),
    );
  }
}
