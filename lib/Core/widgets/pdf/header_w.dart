import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget getHeader({
  required String title,
  required String email,
  required String form,
  required double headerHeight,
  int? minutes,
}) {
  return pw.Directionality(
    textDirection: pw.TextDirection.rtl,
    child: pw.SizedBox(
      height: headerHeight,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(),
              pw.Text(
                "اسم الاختبار :  $title",
                style: pw.TextStyle(
                  fontSize: 15,
                  // fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "اسم الاستاذ :  $email",
                style: pw.TextStyle(
                  fontSize: 15,
                  // fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(),
              pw.Text(
                "النموذج :  $form",
                style: pw.TextStyle(
                  fontSize: 15,
                  // fontWeight: pw.FontWeight.bold,
                ),
              ),
              minutes != null
                  ? pw.Text(
                      "المدة :  ${"${(minutes)} دقيقة"}",
                      style: pw.TextStyle(
                        fontSize: 15,
                        // fontWeight: pw.FontWeight.bold,
                      ),
                    )
                  : pw.SizedBox(),
            ],
          ),
        ],
      ),
    ),
  );
}
