import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/bubble.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/row_bubbles.dart';

import '../../../Core/functions/show_alert.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';

class FormRowWidget extends StatelessWidget {
  const FormRowWidget({
    super.key,
    required this.selected,
    required this.rowBubbles,
    required this.onUpdate,
  });
  final int selected;
  final RowBubbles rowBubbles;
  final void Function(int) onUpdate;
  @override
  Widget build(BuildContext context) {
    return FormImageWidget(
      images: rowBubbles.bubbles,
      selectedBubble: selected,
      onUpdate: onUpdate,
    );
  }
}

class FormImageWidget extends StatelessWidget {
  const FormImageWidget({
    super.key,
    required this.images,
    required this.onUpdate,
    required this.selectedBubble,
  });
  final int? selectedBubble;
  final void Function(int) onUpdate;
  final List<Bubble> images;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SizesResources.s2),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (i) => InkWell(
              onTap: () {
                showAlert(
                  context: context,
                  title: "تعديل اختيار الطالب",
                  body: "هل انت متاكد من انك تريد تعديل اختيار الطالب",
                  onAgree: () {
                    onUpdate(i);
                  },
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.memory(
                    (images[i].image),
                    width: SpacingResources.mainWidth(context) / 4,
                    fit: BoxFit.fitWidth,
                  ),
                  if (selectedBubble == i)
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: ColorsResources.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
