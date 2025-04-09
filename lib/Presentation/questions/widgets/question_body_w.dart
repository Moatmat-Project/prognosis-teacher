import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question_word_color.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Presentation/equations/widget/equation_text_builder_w.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../equations/widget/math_tex_w.dart';
import '../../equations/widget/text_w.dart';

class QuestionBodyWidget extends StatefulWidget {
  const QuestionBodyWidget({super.key, required this.question});
  final Question question;
  @override
  State<QuestionBodyWidget> createState() => _QuestionBodyWidgetState();
}

class _QuestionBodyWidgetState extends State<QuestionBodyWidget> {
  @override
  void didUpdateWidget(covariant QuestionBodyWidget oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            //
            //
            if (widget.question.upperImageText != null && widget.question.upperImageText != "")
              QuestionTextBuilderWidget(
                text: widget.question.upperImageText!,
                equations: widget.question.equations,
                colors: const [],
              ),
            //
            if (widget.question.image != null && widget.question.image != "") ...[
              const SizedBox(height: SizesResources.s2),
              QuestionImageBuilderWidget(image: widget.question.image!),
              const SizedBox(height: SizesResources.s2),
            ],

            //
            if (widget.question.lowerImageText != null && widget.question.lowerImageText != "") ...[
              const SizedBox(height: SizesResources.s2),
              QuestionTextBuilderWidget(
                text: widget.question.lowerImageText!,
                fontSize: 14,
                equations: widget.question.equations,
                colors: widget.question.colors,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class QuestionImageBuilderWidget extends StatelessWidget {
  const QuestionImageBuilderWidget({
    super.key,
    required this.image,
    this.radius,
    this.width,
  });

  final String image;
  final double? width;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    if (image.contains("supabase")) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.circular(12),
        child: CachedNetworkImage(
          width: width ?? SpacingResources.mainWidth(context) - 50,
          imageUrl: image,
          fit: width != null ? BoxFit.fitWidth : null,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: width ?? SpacingResources.mainWidth(context) - 50,
              height: 150,
              color: Colors.grey[300],
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.circular(12),
        child: Image.asset(
          image,
          width: SpacingResources.mainWidth(context) - 50,
        ),
      );
    }
  }
}

class QuestionTextBuilderWidget extends StatefulWidget {
  const QuestionTextBuilderWidget({
    super.key,
    required this.text,
    required this.equations,
    required this.colors,
    this.wrapAlignment,
    this.width,
    this.fontSize,
    this.mathFontSize,
    this.fontWeight,
    this.disableNewLines = false,
  });
  final double? fontSize;
  final double? mathFontSize;
  final FontWeight? fontWeight;
  final double? width;
  final String text;
  final List<String> equations;
  final List<QuestionWordColor> colors;
  final WrapAlignment? wrapAlignment;
  final bool disableNewLines;

  @override
  State<QuestionTextBuilderWidget> createState() => _QuestionTextBuilderWidgetState();
}

class _QuestionTextBuilderWidgetState extends State<QuestionTextBuilderWidget> {
  late List<String> words;
  late List<Color?> colors;

  @override
  void initState() {
    //
    words = widget.text.split(RegExp(r'(?<=\n)|(?=\n)| '));
    //
    colors = [];
    //
    for (int i = 0; i < words.length; i++) {
      colors.add(null);
    }

    for (var color in widget.colors) {
      if (color.index >= colors.length - 1) {
        continue;
      }
      colors[color.index] = color.color;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant QuestionTextBuilderWidget oldWidget) {
    //
    words = widget.text.split(RegExp(r'(?<=\n)|(?=\n)| '));
    //
    colors = [];
    //
    for (int i = 0; i < words.length; i++) {
      colors.add(null);
    }
    for (var color in widget.colors) {
      if (color.index >= colors.length - 1) {
        continue;
      }
      colors[color.index] = color.color;
    }
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? SpacingResources.mainWidth(context) - SpacingResources.sidePadding,
      child: Directionality(
        textDirection: isArabic(widget.text) ? TextDirection.rtl : TextDirection.ltr,
        child: Wrap(
          alignment: widget.wrapAlignment ?? WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(words.length, (index) {
            //
            if (containsEscapeSequence(words[index])) {
              //
              String equation = getEquationByFromText(words[index]);
              //
              return LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth,
                      minHeight: (widget.mathFontSize ?? 15) * 2.7,
                    ),
                    child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: MathTexWidget(
                          equation: equation,
                          color: colors[index],
                          fontWeight: widget.fontWeight,
                          fontSize: widget.mathFontSize ?? 14,
                        ),
                      ),
                    ),
                  );
                },
              );
              //
            } else {
              //
              if (words[index] == '\n' && !widget.disableNewLines) {
                //
                return const NewLineWidget();
                //
              } else {
                //
                return SizedBox(
                  height: (widget.fontSize ?? 15) * 2,
                  child: TextWidget(
                    text: words[index],
                    color: colors[index],
                    fontSize: widget.fontSize ?? 14,
                    fontWeight: widget.fontWeight,
                  ),
                );
                //
              }
            }
          }),
        ),
      ),
    );
  }

  bool containsEscapeSequence(String input) {
    RegExp regex = RegExp(r'\\[0-9]');
    return regex.hasMatch(input);
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  String getEquationByFromText(String text) {
    //
    text = text.replaceAll("\\", "");
    //
    int index = int.tryParse(text) ?? 0;
    //
    if (index <= (widget.equations.length - 1) && widget.equations.isNotEmpty) {
      text = widget.equations[index];
    }
    //
    return text;
  }
}
