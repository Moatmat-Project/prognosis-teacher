import 'dart:io';

import 'package:excel/excel.dart';

class ExcelReaderService {
  readResults(String file) {
    //
    var bytes = File(file).readAsBytesSync();
    //
    var excel = Excel.decodeBytes(bytes);
    //
    for (var table in excel.tables.keys) {
      final t = excel.tables[table];
      if (t != null) {
        for (var row in t.rows) {
          // final result = rowToResult(row);
        }
      }
    }
  }

  // Result rowToResult(List<Data?> row) {
  //   return Result(
  //     id: row[0],
  //     userName: row[1],
  //     mark: row[2],
  //     testId: null,
  //     bankId: null,
  //     wrongAnswers: row[3],
  //     date: row[4],
  //     period: row[5],
  //     testName: row[6],
  //     userNumber: row[7],
  //     userId: "",
  //     answers: row[8],
  //   );
  // }
}
