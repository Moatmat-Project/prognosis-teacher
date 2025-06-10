import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/fonts_r.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Core/widgets/ui/divider_w.dart';
import 'package:moatmat_teacher/Presentation/equations/view/create_equation_v.dart';
import 'package:moatmat_teacher/Presentation/equations/widget/equation_text_builder_w.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/ui/box_label_w.dart';

class InsertEquationView extends StatefulWidget {
  const InsertEquationView({
    super.key,
    required this.text,
    required this.result,
    required this.equations,
  });
  final String text;
  final List<String> equations;
  final Function(List<String> equations, String text) result;
  @override
  State<InsertEquationView> createState() => _InsertEquationViewState();
}

class _InsertEquationViewState extends State<InsertEquationView> {
  late final TextEditingController _controller;
  late String text;
  List<String> words = [];
  List<String> equations = [];

  @override
  void initState() {
    text = widget.text;
    words = text.split(RegExp(r'(?<=\n)|(?=\n)| '));
    equations = List<String>.from(widget.equations);
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(() {
      setState(() {
        text = _controller.value.text;
        words = text.split(RegExp(r'(?<=\n)|(?=\n)| '));
      });
    });
    super.initState();
  }

  addFormula(int index) {
    print("object");
    int offset = _controller.selection.baseOffset;
    String text = _controller.text;
    if (offset != -1) {
      text = '${text.substring(0, offset)} \\$index ${text.substring(offset)}';
      _controller.text = text;
    } else {
      text += ' \\$index ';
      _controller.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تحديد موقع المعادلات"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateEquationView(
                    result: (String result) {
                      setState(() {
                        equations.add(result);
                      });
                    },
                  ),
                ),
              );
            },
            child: const Text("إضافة معادلة"),
          ),
        ],
      ),
      body: ListView(
        children: [
              EquationTextBuilderWidget(
                text: text,
                equations: equations,
              ),
              const SizedBox(height: SizesResources.s3),
              MyTextFormFieldWidget(
                controller: _controller,
                minLines: 1,
                maxLines: 20,
                onChanged: (p0) {},
              ),
              const SizedBox(height: SizesResources.s3),
              const BoxLabelWidget(text: "ادرج المعادلات عن طريق استخدام رمز المعادلة او تحديد موقع المعادلة باستخدام المؤشر والضغط مطولا على المعادلة المطلوبة"),
              const DividerWidget(),
            ] +
            List.generate(
              equations.length,
              (index) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: SpacingResources.sidePadding,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsResources.onPrimary,
                      border: Border.all(color: ColorsResources.primary),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: SpacingResources.mainWidth(context),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateEquationView(
                                equation: equations[index],
                                result: (String result) {
                                  setState(() {
                                    equations[index] = result;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          addFormula(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingResources.sidePadding,
                            vertical: SpacingResources.sidePadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "المعادلة : ",
                                        style: FontsResources.styleMedium(),
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Math.tex(
                                          equations[index],
                                          textStyle: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "الرمز : ",
                                        style: FontsResources.styleRegular(),
                                      ),
                                      Text(
                                        "\\$index",
                                        textDirection: TextDirection.ltr,
                                        style: FontsResources.styleRegular(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: SizesResources.s2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "اضغط مطولا لارفاق المعادلة",
                                        style: FontsResources.styleRegular(
                                          size: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    equations.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: ColorsResources.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButtonWidget(
              text: "حفظ",
              onPressed: () async {
                widget.result(equations, text);
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
}

bool containsArabic(String word) {
  // Regular expression to match Arabic characters
  RegExp arabicRegExp = RegExp(r'[\u0600-\u06FF]');
  // Check if the word contains any Arabic characters
  return arabicRegExp.hasMatch(word);
}
