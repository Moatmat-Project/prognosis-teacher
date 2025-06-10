import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../Core/functions/show_alert.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/scanner/domain/entities/bubble.dart';

class IDColumnWidget extends StatefulWidget {
  const IDColumnWidget({
    super.key,
    required this.bubbles,
    required this.selectedBubble,
    required this.onUpdate,
  });
  //
  final List<Bubble> bubbles;
  //
  final int? selectedBubble;
  //
  final void Function(int) onUpdate;
  //
  @override
  State<IDColumnWidget> createState() => _IDColumnWidgetState();
}

class _IDColumnWidgetState extends State<IDColumnWidget> {
  //
  late final List<Uint8List> images;
  //

  //
  @override
  void initState() {
    //
    images = widget.bubbles.map((b) {
      return b.image;
    }).toList();
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SpacingResources.mainWidth(context),
      child: Stack(
        children: [
          //
          ImagesIDColumnWidget(
            images: images,
            onUpdate: widget.onUpdate,
            selectedBubble: widget.selectedBubble,
          ),
          //
        ],
      ),
    );
  }
}

class ImagesIDColumnWidget extends StatelessWidget {
  const ImagesIDColumnWidget({
    super.key,
    required this.images,
    required this.onUpdate,
    required this.selectedBubble,
  });
  final int? selectedBubble;
  final void Function(int) onUpdate;
  final List<Uint8List> images;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
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
                  (images[i]),
                  width: SpacingResources.mainWidth(context) / 7,
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
    );
  }
}
