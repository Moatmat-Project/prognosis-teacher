import 'package:pdf/widgets.dart' as pw;

pw.Widget getFooter({
  required double footerHeight,
  required int pageNumber,
  required int pagesCount,
  bool isLastPage = false,
}) {
  return pw.Footer(
    margin: pw.EdgeInsets.zero,
    padding: pw.EdgeInsets.zero,
    title: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.SizedBox(
        height: footerHeight,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (isLastPage) ...[
                  pw.SizedBox(width: 50),
                  pw.Text(
                    "مؤتمت... معك في كل اختيار",
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
    leading: pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.SizedBox(
        height: footerHeight,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "رقم الصفحة : $pageNumber",
                  // "صفحة  $pageNumber  من  $pagesCount ",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
