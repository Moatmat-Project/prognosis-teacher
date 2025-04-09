import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_teacher/Core/functions/parsers/period_to_text_f.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../../../Features/students/domain/entities/result.dart';

Future<void> exportResultsPdf(List<Result> results, String name) async {
  final pdf = pw.Document();
  //
  //
  var reqFont = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Tajawal/Tajawal-Regular.ttf"),
  );
  var boldFont = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Tajawal/Tajawal-Bold.ttf"),
  );

  // create pdf
  // 21.0 * (72.0 / 2.54)
  pdf.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      pageFormat: PdfPageFormat.a5,
      theme: pw.ThemeData.withFont(
        base: reqFont,
        bold: boldFont,
      ),
      build: (context) {
        return [getHeaderRow()] +
            results
                .map<pw.Widget>(
                  (e) => getResultRow(e),
                )
                .toList();
      },
    ),
  );
  // Save the PDF file to local storage
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/results_of_${name.replaceAll(" ", "_")}.pdf';
  final file = File(filePath);
  var pdfFile = await file.writeAsBytes(await pdf.save());
  // Open the PDF file
  if (kDebugMode) {
    OpenFile.open(pdfFile.path);
  } else {
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
    );
  }
}

pw.Widget getResultRow(Result result) {
  return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        width: 588,
        // height: 20,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            width: 0.5,
            color: PdfColors.black,
          ),
        ),
        child: pw.Row(
          children: [
            pw.SizedBox(width: 5),
            // 1 - id
            getRowCell(
              result.userNumber.toString().padLeft(6, "0"),
              1,
            ),

            // 2 - name
            getRowCell(
              result.userName,
              1,
            ),

            // 3 - mark
            getRowCell(
              "%${result.mark}",
              1,
            ),

            // 4 - wrong answers
            getRowCell(getWrongAnswers(result.wrongAnswers), 2),

            // 5 - date
            getRowCell(
              result.date.toString().substring(0, 10),
              1,
            ),

            // 6 - time
            getRowCell(
              result.date.toString().substring(11, 19),
              1,
            ),

            // 7 - period
            getRowCell(
              periodToTextFunction(result.period),
              1,
            ),

            // 8 - t/b name
            getRowCell(
              result.testName,
              2,
            ),
            pw.SizedBox(width: 5),
          ],
        ),
      ));
}

String getWrongAnswers(List<int?> wrongAnswers) {
  List<int?> answers = [];
  for (int i = 0; i < wrongAnswers.length; i++) {
    if (wrongAnswers[i] == -1) {
      continue;
    } else {
      answers.add(i + 1);
    }
  }
  return answers.isNotEmpty ? answers.join(' , ') : "بيانات ناقصة";
}

pw.Widget getHeaderRow() {
  return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        height: 20,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            width: 0.5,
            color: PdfColors.black,
          ),
        ),
        child: pw.Row(
          children: [
            pw.SizedBox(width: 5),
            // 1 - id
            getColumnCell(
              "رقم الطالب",
              1,
            ),

            // 2 - name
            getColumnCell(
              "اسم الطالب",
              1,
            ),

            // 3 - mark
            getColumnCell(
              "العلامة",
              1,
            ),

            // 4 - wrong answers
            getColumnCell(
              "الأسئلة الخاطئة",
              2,
            ),

            // 5 - date
            getColumnCell(
              "التاريخ",
              1,
            ),

            // 6 - time
            getColumnCell(
              "الوقت",
              1,
            ),

            // 7 - period
            getColumnCell(
              "المدة",
              1,
            ),

            // 8 - t/b name
            getColumnCell(
              "الاختبار",
              2,
            ),
            pw.SizedBox(width: 5),
          ],
        ),
      ));
}

pw.Widget getRowCell(String content, int flex) {
  return pw.Expanded(
      flex: flex,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(1),
              child: pw.Text(
                content,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 7),
              ),
            ),
          )
        ],
      ));
}

pw.Widget getColumnCell(String title, int flex) {
  return pw.Expanded(
    flex: flex,
    child: pw.Container(
        color: PdfColors.black,
        child: pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: pw.Text(
            title,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 6,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        )),
  );
}
