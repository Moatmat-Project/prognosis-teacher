import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Presentation/tests/widgets/chewie_player_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../Features/tests/domain/entities/question/question.dart';
import '../../resources/sizes_resources.dart';
import '../fields/elevated_button_widget.dart';

class QuestionExplainView extends StatefulWidget {
  const QuestionExplainView({super.key, required this.question});
  final Question question;
  @override
  State<QuestionExplainView> createState() => _QuestionExplainViewState();
}

class _QuestionExplainViewState extends State<QuestionExplainView> {
  @override
  void initState() {
    if (widget.question.video != null) {
    } else {}
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الشرح"),
      ),
      body: Column(
        children: [
          if (widget.question.video != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChewiePlayerWidget(videoUrl: widget.question.video!),
              ],
            ),
          if (widget.question.explain != null) ...[
            const SizedBox(height: SizesResources.s4),
            SizedBox(
              child: Text(
                widget.question.explain!,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: SizesResources.s10,
          left: SizesResources.s2,
          right: SizesResources.s2,
        ),
        child: ElevatedButtonWidget(
          text: "عودة",
          onPressed: () async {},
        ),
      ),
    );
  }
}
