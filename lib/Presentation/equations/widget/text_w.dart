import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.fontFamily,
  });
  final String text;
  final double? fontSize;
  final String?     fontFamily;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic(text) ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Text(
          " $text",
          textAlign: textAlign,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            color: color ?? ColorsResources.blackText1,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
