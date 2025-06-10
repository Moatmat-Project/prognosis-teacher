import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../Core/resources/colors_r.dart';

class MathTexWidget extends StatelessWidget {
  const MathTexWidget({
    super.key,
    required this.equation,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.fontFamily,
  });
  final double? fontSize;
  final String? fontFamily;
  final String equation;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Math.tex(
          equation,
          textScaleFactor: 1.2,
          options: MathOptions(
            mathFontOptions: FontOptions(
              fontWeight: FontWeight.bold,
            ),
            fontSize: fontSize ?? 15,
            color: color ?? ColorsResources.blackText1,
          ),
          textStyle: TextStyle(
            fontSize: fontSize ?? 15,
            fontWeight: FontWeight.w500,
            color: color ?? ColorsResources.blackText1,
          ),
          onErrorFallback: (errs) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                " الصيغة غير موجودة او تحتوي اخطاء ",
                textAlign: textAlign,
                style: TextStyle(
                  color: ColorsResources.red,
                  fontSize: fontSize ?? 15,
                  fontFamily: fontFamily,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
