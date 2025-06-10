import 'package:flutter/material.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/view/question_explain_v.dart';
import '../../../Features/tests/domain/entities/question/question.dart';
import 'question_body_w.dart';

class QuestionBox extends StatefulWidget {
  const QuestionBox({
    super.key,
    required this.question,
  });
  final Question question;

  @override
  State<QuestionBox> createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox> {
  bool didAnswer = true;
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
            horizontal: SpacingResources.sidePadding / 2,
          ),
          width: SpacingResources.mainWidth(context),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: ShadowsResources.mainBoxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QuestionBodyWidget(question: widget.question),
              const SizedBox(height: SizesResources.s2),
              if (didAnswer &&
                      (widget.question.explain != null &&
                          widget.question.explain!.isNotEmpty) ||
                  (widget.question.video != null &&
                      widget.question.video != ""))
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuestionExplainView(
                          question: widget.question,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: ColorsResources.blackText2,
                  ),
                ),
              const SizedBox(height: SizesResources.s2),
            ],
          ),
        ),
      ],
    );
  }
}

class TopItems extends StatelessWidget {
  const TopItems({
    super.key,
    required this.onShare,
    required this.onReport,
    required this.onLike,
    required this.liked,
  });
  final VoidCallback onShare;
  final VoidCallback onReport;
  final Function(bool like) onLike;
  final bool liked;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onReport,
          icon: const Icon(
            Icons.report_problem_outlined,
            size: 18,
            color: Colors.cyan,
          ),
        ),
        IconButton(
          onPressed: onShare,
          icon: const Icon(
            Icons.share,
            size: 16,
            color: ColorsResources.green,
          ),
        ),
        IconButton(
          onPressed: () {
            onLike(!liked);
          },
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class ExploreImage extends StatelessWidget {
  const ExploreImage({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: SpacingResources.mainWidth(context),
          height: MediaQuery.sizeOf(context).height,
          child: InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Image.network(
              image,
            ),
          ),
        ),
      ),
    );
  }
}
