import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../../Features/students/data/responses/get_my_students_statistics_response.dart';

Future<void> exportGroupAttendancePdf({
  required List<StudentRowDetails> rows,
  required List<AttendanceSet> sets,
}) async {
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
        return [getHeaderRow(sets: sets)] +
            rows
                .map<pw.Widget>(
                  (e) => getRecordRow(
                    row: e,
                    sets: sets,
                  ),
                )
                .toList();
      },
    ),
  );
  // Save the PDF file to local storage
  var directory = await getApplicationDocumentsDirectory();
  // String filePath = '${directory.path}/ملف_الحضور_لمجموعةـ${(group.name.replaceAll("-", " "))}.pdf';
  String filePath = '${directory.path}/ملف_الحضور_لمجموعة.pdf';
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

pw.Widget getRecordRow({
  required List<AttendanceSet> sets,
  required StudentRowDetails row,
}) {
  return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        width: 588,
        // height: 20,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            width: 0.4,
            color: PdfColor.fromHex("#4D4D4D"),
          ),
        ),
        child: pw.Row(
          children: [
            pw.SizedBox(width: 5),
            // 1 - id
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8),
              child: pw.SizedBox(
                width: 20,
                child: getRowCell(
                  row.userId.toString().padLeft(6, "0"),
                  1,
                ),
              ),
            ),

            // 2 - name
            getRowCell(
              row.name,
              1,
            ),

            // 3 - absents
            getRowCell(
              "0",
              1,
            ),

            ...sets.map(
              (e) => getRowCell(
                row.records.any((record) => record.attendanceSetId == e.id.toString()) ? "ح" : "غ",
                2,
              ),
            ),

            pw.SizedBox(width: 5),
          ],
        ),
      ));
}

pw.Widget getHeaderRow({required List<AttendanceSet> sets}) {
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
            width: 0.4,
            color: PdfColor.fromHex("#4D4D4D"),
          ),
        ),
        child: pw.Row(
          children: [
            pw.SizedBox(width: 5),
            // 1 - id

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8),
              child: pw.SizedBox(
                width: 20,
                child: getColumnCell(
                  "رقم الطالب",
                  1,
                ),
              ),
            ),

            // 2 - name
            getColumnCell(
              "اسم الطالب",
              1,
            ),

            // 3 - mark
            getColumnCell(
              "الغيابات",
              1,
            ),

            // 4 - wrong answers
            ...sets.map(
              (e) => getColumnCell(
                e.title.length > 16 ? e.title.substring(0, 15) : e.title,
                2,
              ),
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
                style: const pw.TextStyle(fontSize: 4),
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
            fontSize: 4,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
