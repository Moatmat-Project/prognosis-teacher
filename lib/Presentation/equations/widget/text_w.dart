import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.text, this.color, this.fontSize, this.fontWeight});
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic(text) ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          " $text",
          style: TextStyle(
            fontSize: fontSize ?? 16,
            color: color ?? ColorsResources.blackText1,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
