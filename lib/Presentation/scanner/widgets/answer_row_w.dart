import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';

import '../../../Features/scanner/domain/entities/bubble.dart';

class AnswerRowWidget extends StatefulWidget {
  const AnswerRowWidget({
    super.key,
    required this.bubbles,
    required this.selectedAnswer,
    required this.trueAnswer,
    required this.onUpdate,
  });
  //
  final List<Bubble> bubbles;
  //
  final int? selectedAnswer;
  //
  final int trueAnswer;
  //
  final void Function(int) onUpdate;
  //
  @override
  State<AnswerRowWidget> createState() => _AnswerRowWidgetState();
}

class _AnswerRowWidgetState extends State<AnswerRowWidget> {
  //
  late int? selectedAnswer;

  @override
  void initState() {
    selectedAnswer = widget.selectedAnswer;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    selectedAnswer = widget.selectedAnswer;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SpacingResources.mainWidth(context),
      child: Stack(
        children: [
          ImagesAnswerRowWidget(
            selected: widget.selectedAnswer,
            trueSelection: widget.trueAnswer,
            bubbles: widget.bubbles,
            onTap: widget.onUpdate,
          ),
          //
        ],
      ),
    );
  }
}

class ImagesAnswerRowWidget extends StatelessWidget {
  const ImagesAnswerRowWidget({
    super.key,
    required this.bubbles,
    required this.onTap,
    required this.selected,
    required this.trueSelection,
  });
  final int? selected;
  final int trueSelection;
  final void Function(int) onTap;
  final List<Bubble> bubbles;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (SpacingResources.mainWidth(context) / bubbles.length),
      child: Row(
        children: List.generate(
          bubbles.length,
          (i) => Expanded(
            child: InkWell(
              onLongPress: () {},
              onTap: () {
                showAlert(
                  context: context,
                  title: "تعديل اختيار الطالب",
                  body: "هل انت متاكد من انك تريد تعديل اختيار الطالب",
                  onAgree: () {
                    onTap(i);
                  },
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.memory(
                    (bubbles[i].image),
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                  Center(child: getCircle(i)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCircle(int index) {
    //
    bool isSelected = index == selected;
    //
    bool isTrue = index - 1 == trueSelection;
    //
    if (index == 0) {
      if (selected == trueSelection + 1) {
        return const Icon(
          Icons.check,
          color: ColorsResources.green,
          size: 35,
        );
      } else {
        return const Icon(
          Icons.close,
          color: ColorsResources.red,
          size: 35,
        );
      }
    }
    //
    if (isSelected) {
      return Container(
        width: 25,
        decoration: BoxDecoration(
          color: isTrue ? ColorsResources.green : ColorsResources.red,
          shape: BoxShape.circle,
          border: Border.all(
            width: 2.0,
          ),
        ),
      );
    } else if (isTrue) {
      return Container(
        width: 25,
        decoration: BoxDecoration(
          color: ColorsResources.orangeText,
          shape: BoxShape.circle,
          border: Border.all(
            width: 2.0,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
    //
  }
}
