import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../Features/tests/domain/entities/question/question.dart';
import '../../../Presentation/videos/view/video_player_w.dart';
import '../../resources/sizes_resources.dart';
import '../fields/elevated_button_widget.dart';

class QuestionExplainView extends StatefulWidget {
  const QuestionExplainView({super.key, required this.question});
  final Question question;
  @override
  State<QuestionExplainView> createState() => _QuestionExplainViewState();
}

class _QuestionExplainViewState extends State<QuestionExplainView> {
  late FlickManager? _flickManager;
  @override
  void initState() {
    if (widget.question.video != null) {
      _flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.question.video ?? ""),
        ),
      );
    } else {
      _flickManager = null;
    }
    super.initState();
  }

  @override
  void dispose() {
    _flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final bool? shouldPop =
            _flickManager?.flickControlManager?.isFullscreen;
        if (shouldPop ?? false) {
          _flickManager?.flickControlManager?.exitFullscreen();
        } else {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الشرح"),
        ),
        body: Column(
          children: [
            if (_flickManager != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VideoPlayerWidget(flickManager: _flickManager!),
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
      ),
    );
  }
}
