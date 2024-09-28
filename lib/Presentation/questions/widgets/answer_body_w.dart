import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/answer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import 'question_body_w.dart';

class AnswerBodyWidget extends StatefulWidget {
  const AnswerBodyWidget({super.key, required this.answer});
  final Answer answer;
  @override
  State<AnswerBodyWidget> createState() => _AnswerBodyWidgetState();
}

class _AnswerBodyWidgetState extends State<AnswerBodyWidget> {
  @override
  void didUpdateWidget(covariant AnswerBodyWidget oldWidget) {
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
            if (widget.answer.text != null && widget.answer.text != "") ...[
              const SizedBox(height: SizesResources.s2),
              QuestionTextBuilderWidget(
                text: widget.answer.text!,
                equations: widget.answer.equations ?? [],
                colors: const [],
              ),
            ],
            //
            if (widget.answer.image != null && widget.answer.image != "") ...[
              const SizedBox(height: SizesResources.s2),
              AnswerImageBuilderWidget(image: widget.answer.image!),
              const SizedBox(height: SizesResources.s2),
            ],
            //
          ],
        ),
      ],
    );
  }
}


class AnswerImageBuilderWidget extends StatelessWidget {
  const AnswerImageBuilderWidget({
    super.key,
    required this.image,
    this.radius,
    this.width,
    this.fit,
  });
  final double? width;
  final String image;
  final BorderRadius? radius;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (image.contains("supabase")) {
      return SizedBox(
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            image,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: SpacingResources.mainWidth(context) - 120,
                  height: 150,
                  color: Colors.grey[300],
                ),
              );
            },
            width: SpacingResources.mainWidth(context) - 120,
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          image,
          width: SpacingResources.mainWidth(context) / 2,
        ),
      );
    }
  }
}
