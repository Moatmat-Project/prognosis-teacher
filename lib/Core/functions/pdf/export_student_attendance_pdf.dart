import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../../../Features/students/domain/entities/user_data.dart';

Future<void> exportStudentAttendancePdf({
  required UserData userData,
  required List<AttendanceSet> sets,
  required List<AttendanceRecord> records,
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
        return [getHeaderRow()] +
            sets
                .map<pw.Widget>(
                  (set) => getRecordRow(set, records.where((e) => e.attendanceSetId == set.id.toString()).firstOrNull),
                )
                .toList();
      },
    ),
  );
  // Save the PDF file to local storage
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/ملف_الحضور_للطالب_${(userData.name.replaceAll("-", " "))}.pdf';
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

pw.Widget getRecordRow(AttendanceSet set, AttendanceRecord? record) {
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
              set.title,
              1,
            ),

            // 2 - name
            getRowCell(
              set.date.toString().substring(0, 10),
              1,
            ),

            // 5 - date
            getRowCell(
              record?.date.toString().substring(0, 10) ?? "غياب",
              1,
            ),

            // 6 - time
            getRowCell(
              record?.date.toString().substring(11, 19) ?? "",
              1,
            ),

            pw.SizedBox(width: 5),
          ],
        ),
      ));
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
            // 1
            getColumnCell(
              "اسم الجلسة",
              1,
            ),

            // 2
            getColumnCell(
              "تاريخ الجلسة",
              1,
            ),

            // 3
            getColumnCell(
              "تاريخ الحضور",
              1,
            ),

            // 4
            getColumnCell(
              "وقت الحضور",
              1,
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
