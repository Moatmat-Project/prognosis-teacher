import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Features/attendance/domain/entities/attendance_record.dart';

exportAttendanceSetExcel({
  required AttendanceSet set,
  required List<AttendanceRecord> records,
}) async {
  // Create an Excel document
  var excel = Excel.createExcel();
  // Access the sheet named 'resultsSheet'
  Sheet resultsSheet = excel['Sheet1'];
  // Populate the sheet with data
  resultsSheet.appendRow([
    // 1 - id
    (TextCellValue("رقم الطالب")),
    // 2 - name
    (TextCellValue("اسم الطالب")),
    // 7 - date
    (TextCellValue("التاديخ")),
    // 8 - time
    (TextCellValue("الوقت")),
    //
  ]);
  // Example headers
  for (var record in records) {
    resultsSheet.appendRow(record.toExcelRow());
  }
  //
  // Save the file to the local storage
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/ملف_الحضور_لجلسةـ${(set.title.replaceAll("-", " "))}.xlsx';
  var fileBytes = excel.save();
  if (fileBytes != null) {
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }
  if (kDebugMode) {
    OpenFile.open(filePath);
  } else {
    await Share.shareXFiles(
      [XFile(filePath)],
    );
  }
}
