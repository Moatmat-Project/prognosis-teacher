import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Features/students/domain/entities/result.dart';

exportResultsExcel({
  required String name,
  required List<Result> results,
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
    // 3 - mark
    (TextCellValue("العلامة")),
    // 4 - test id
    (TextCellValue("رقم البنك")),
    // 5 - bank id
    (TextCellValue("رقم الاختبار")),
    // 6 - wrong answers
    (TextCellValue("الإجابات الخاطئة")),
    // 7 - date
    (TextCellValue("التاديخ")),
    // 8 - time
    (TextCellValue("الوقت")),
    // 9 - period
    (TextCellValue("المدة")),
    // 10 - t/b name
    (TextCellValue("الاسم")),
    //
  ]);
  // Example headers
  for (var result in results) {
    resultsSheet.appendRow(result.toExcelRow());
  }
  //
  // Save the file to the local storage
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/results_of_${name.replaceAll(" ", "_")}.xlsx';
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
