import 'package:excel/excel.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';

import '../../../../Presentation/statistics/state/bloc/export_students_statistics_bloc.dart';

class GetMyStudentsStatisticsResponse {
  final List<StudentRowDetails> rows;
  final List<(int, String)> tests;

  GetMyStudentsStatisticsResponse({
    required this.rows,
    required this.tests,
  });
}

class StudentRowDetails {
  final String name;
  final String userId;
  final List<StudentTestMarkDetails> marks;
  final List<AttendanceRecord> records;

  StudentRowDetails({
    required this.name,
    required this.userId,
    required this.marks,
    required this.records,
  });

  List<StatisticsCellValue> toExcelRow({
    //
    List<int>? setsIds,
    List<int>? testsIds,
    //
    required void Function({
      required double average,
    }) onGetAverage,
  }) {
    ///
    String studentId;
    String studentName;
    double studentAverage = 0.0;
    String studentRate = '        A        ';
    int studentTestsAbsents = 0, studentSetsAbsents = 0;
    List<double?> studentMarks = List.filled(testsIds?.length ?? 0, null);

    ///
    studentId = userId.toString().padLeft(6, "0");
    studentName = name;

    ///
    for (int i = 0; i < (testsIds?.length ?? 0); i++) {
      if (!marks.any((e) {
        bool value = e.testId == testsIds![i];
        if (value) {
          studentMarks[i] = (e.mark);
        }
        return value;
      })) {
        studentTestsAbsents++;
      }
    }

    ///
    for (int i = 0; i < (setsIds?.length ?? 0); i++) {
      if (!records.any((e) => e.attendanceSetId == setsIds![i].toString())) {
        studentSetsAbsents++;
      }
    }

    ///
    final marksSum = studentMarks.where((e) => e != null).fold(0, (sum, element) => sum + element!.toInt());
    if (marksSum > 0) {
      studentAverage = marksSum / ((testsIds?.length ?? 0) - studentTestsAbsents);
      studentAverage = double.parse(studentAverage.toStringAsPrecision(2));
    } else {
      studentAverage = 0.0;
    }
    onGetAverage(average: studentAverage);

    return [
      StatisticsCellValue(value: TextCellValue(studentId)),
      StatisticsCellValue(value: TextCellValue(studentName)),
      StatisticsCellValue(
        value: DoubleCellValue(studentAverage),
        style: studentTestsAbsents > 0 ? CellStyle(backgroundColorHex: ExcelColor.yellow100) : null,
      ),
      StatisticsCellValue(value: TextCellValue(studentRate)),
      if (testsIds?.isNotEmpty ?? false) StatisticsCellValue(value: IntCellValue(studentTestsAbsents)),
      if (setsIds?.isNotEmpty ?? false) StatisticsCellValue(value: IntCellValue(studentSetsAbsents)),
      if (testsIds?.isNotEmpty ?? false)
        ...List.generate(
          studentMarks.length,
          (i) {
            final mark = studentMarks[i];
            final style = CellStyle(
              numberFormat: NumFormat.standard_2,
              fontColorHex: mark == null ? ExcelColor.red : ExcelColor.black,
            );
            if (mark == null) {
              return StatisticsCellValue(
                value: TextCellValue(" غياب "),
                style: style,
              );
            } else {
              return StatisticsCellValue(
                value: DoubleCellValue(mark),
              );
            }
          },
        ),
      if (setsIds?.isNotEmpty ?? false)
        ...List.generate(
          setsIds!.length,
          (i) {
            final style = CellStyle(
              numberFormat: NumFormat.standard_2,
              fontColorHex: ExcelColor.red,
            );
            if (records.any((e) => e.attendanceSetId == setsIds[i].toString())) {
              return StatisticsCellValue(
                value: TextCellValue(" حضور "),
              );
            } else {
              return StatisticsCellValue(
                value: TextCellValue(
                  "غياب",
                ),
                style: style,
              );
            }
          },
        )
    ];
  }
}

class StudentTestMarkDetails {
  final int testId;
  final double mark;
  final DateTime date;

  StudentTestMarkDetails({
    required this.testId,
    required this.mark,
    required this.date,
  });
}
