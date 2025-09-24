import 'package:excel/excel.dart';
import 'package:moatmat_teacher/Core/functions/parsers/date_to_text_f.dart';
import 'package:moatmat_teacher/Core/functions/parsers/period_to_text_f.dart';
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
    List<StudentTestMarkDetails?> studentMarkDetails = List.filled(testsIds?.length ?? 0, null);

    ///
    studentId = userId.toString().padLeft(6, "0");
    studentName = name;

    ///
    for (int i = 0; i < (testsIds?.length ?? 0); i++) {
      if (!marks.any((e) {
        bool value = e.testId == testsIds![i];
        if (value) {
          studentMarkDetails[i] = (e);
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
    final marksSum = studentMarkDetails.where((e) => e != null).fold(0, (sum, element) => sum + element!.mark.toInt());
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
          studentMarkDetails.length,
          (i) {
            final markDetails = studentMarkDetails[i];
            final style = CellStyle(
              numberFormat: NumFormat.standard_2,
              fontColorHex: markDetails == null ? ExcelColor.red : ExcelColor.black,
            );
            if (markDetails == null) {
              return [
                StatisticsCellValue(
                  value: TextCellValue(" غياب "),
                  style: style,
                ),
                StatisticsCellValue(
                  value: TextCellValue("   "),
                  style: style,
                ),
                StatisticsCellValue(
                  value: TextCellValue("   "),
                  style: style,
                ),
              ];
            } else {
              return [
                StatisticsCellValue(
                  value: DoubleCellValue(markDetails.mark),
                ),
                StatisticsCellValue(
                  value: TextCellValue(dateToTextFunction(markDetails.date)),
                  style: style,
                ),
                StatisticsCellValue(
                  value: TextCellValue(periodToTextFunction(markDetails.period)),
                  style: style,
                ),
              ];
            }
          },
        ).expand((cellPair) => cellPair),
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
  final int period;

  StudentTestMarkDetails({
    required this.testId,
    required this.mark,
    required this.date,
    required this.period,
  });
}
