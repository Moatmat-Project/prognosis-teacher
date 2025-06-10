import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question_word_color.dart';

import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';

class EditColorsView extends StatefulWidget {
  const EditColorsView({super.key, required this.text, required this.colors, required this.result});
  final String text;
  final List<QuestionWordColor>? colors;
  final Function(List<QuestionWordColor>) result;

  @override
  State<EditColorsView> createState() => _EditColorsViewState();
}

class _EditColorsViewState extends State<EditColorsView> {
  late List<QuestionWordColor> colors;
  late Map<int, Color?> data;
  late List<String> words;
  late int selected;
  @override
  void initState() {
    colors = widget.colors ?? [];
    words = widget.text.split(RegExp(r'(?<=\n)|(?=\n)| '));
    selected = 0;
    //
    data = {};
    for (int i = 0; i < words.length; i++) {
      for (var c in colors) {
        if (c.index == i) {
          data[i] = c.color;
        }
      }
    }
    //
    super.initState();
  }

  changeIndexColor(int newIndex) {
    List<int> indexes = colors.map((e) => e.index).toList();
    if (indexes.contains(1)) {
      //
    } else {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("تعديل الالوان"),
        actions: [
          TextButton(
            onPressed: () {
              colors = [];
              data.forEach((key, value) {
                colors.add(
                  QuestionWordColor(
                    index: key,
                    color: value,
                  ),
                );
              });
              //
              widget.result(colors);
              //
              Navigator.of(context).pop();
            },
            child: const Text("حفظ"),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Directionality(
        textDirection: isArabic(widget.text) ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(SpacingResources.sidePadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: double.infinity),
                RichText(
                  text: TextSpan(
                    style: FontsResources.styleMedium(
                      size: 19,
                    ),
                    children: List.generate(
                      words.length,
                      (i) {
                        return TextSpan(
                          text: " ${words[i]} ",
                          style: TextStyle(
                            color: data[i],
                            fontSize: selected == i ? 24 : null,
                            fontWeight: selected == i ? FontWeight.bold : null,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (selected == i) {
                                selected = -1;
                              } else {
                                selected = i;
                              }
                              setState(() {});
                            },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "تغيير الللون",
          onPressed: selected != -1 && widget.text.isNotEmpty
              ? () async {
                  showDialog(
                    builder: (context) => AlertDialog(
                      title: const Text('Pick a color!'),
                      content: SingleChildScrollView(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: ColorPicker(
                            pickerColor: data[selected] ?? ColorsResources.blackText1,
                            enableAlpha: true,
                            hexInputBar: true,
                            labelTypes: const [
                              ColorLabelType.hex,
                              ColorLabelType.hsl,
                              ColorLabelType.hsv,
                              ColorLabelType.rgb,
                            ],
                            onColorChanged: (value) {
                              data[selected] = value;
                            },
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('حفظ'),
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    context: context,
                  );
                }
              : null,
        ),
      ),
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
