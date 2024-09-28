import 'package:flutter/material.dart';

import '../../../Presentation/scanner/widgets/image_display_w.dart';
import '../../resources/colors_r.dart';

String scannerStateText(ScannerState state) {
  String txt = "";
  switch (state) {
    case ScannerState.search:
      txt = "وازي محتوى الورقة مع المربع البنفسجي";
      break;
    case ScannerState.stand:
      txt = "جاري مسح محتويات الورقة \n حافظ على ثبات جهازك";
      break;
  }
  return txt;
}

Color scannerColor(ScannerState state) {
  Color color;
  switch (state) {
    case ScannerState.search:
      color = ColorsResources.primary;
      break;
    case ScannerState.stand:
      color = ColorsResources.green;
      break;
  }
  return color;
}
