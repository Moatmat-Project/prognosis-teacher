import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Features/attendance/domain/entities/attendance_record.dart';

exportStudentAttendanceExcel({
  required UserData userData,
  required List<AttendanceSet> sets,
  required List<AttendanceRecord> records,
}) async {
  // Create an Excel document
  var excel = Excel.createExcel();
  // Access the sheet named 'resultsSheet'
  Sheet resultsSheet = excel['Sheet1'];
  // Populate the sheet with data
  resultsSheet.appendRow([
    // 1 -
    (TextCellValue("اسم الجلسة")),
    // 2 -
    (TextCellValue("تاريخ الجلسة")),
    // 3 -
    (TextCellValue("تاريخ الحضور")),
    // 4 -
    (TextCellValue("وقت الحضور")),
  ]);
  // Example headers
  for (var set in sets) {
    resultsSheet.appendRow(_setToExcelRow(set, records.where((e) => e.attendanceSetId == set.id.toString()).firstOrNull));
  }
  //
  // Save the file to the local storage
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/ملف_الحضور_للطالب_${(userData.name.replaceAll("-", " "))}.xlsx';
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

List<CellValue> _setToExcelRow(AttendanceSet set, AttendanceRecord? record) {
  //
  List<CellValue> cells = [];
  // 1 - id
  cells.add(TextCellValue(set.title));
  // 2 - name
  cells.add(DateCellValue(year: set.date.year, month: set.date.month, day: set.date.day));
  // 3 - name
  cells.add(record != null ? DateCellValue(year: record.date.year, month: record.date.month, day: record.date.day) : TextCellValue("غياب"));
  // 4 - name
  if (record != null) {
    cells.add(TimeCellValue(hour: record.date.hour, minute: record.date.minute));
  }
  //
  return cells;
}
