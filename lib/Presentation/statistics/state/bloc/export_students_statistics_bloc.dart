import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_sets_uc.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_my_students_statistics_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_my_tests_uc.dart';
import 'package:moatmat_teacher/Presentation/statistics/views/export_students_statistics_view.dart';
import 'package:open_file/open_file.dart';
import '../../../../Core/functions/pdf/export_group_attendance_pdf.dart';
import '../../../../Features/students/data/responses/get_my_students_statistics_response.dart';
part 'export_students_statistics_event.dart';
part 'export_students_statistics_state.dart';

class ExportStudentsStatisticsBloc extends Bloc<ExportStudentsStatisticsEvent, ExportStudentsStatisticsState> {
  //
  final GetMyStudentsResultsUc _getMyStudentsResultsUc;
  final GetAttendanceSetsUsecase _getAttendanceSetsUsecase;
  final GetMyTestsUC _getTestsUsecase;
  //
  Sheet? resultsSheet;
  List<int> testsIds = [], setsIds = [];
  List<Result> results = [];
  List<double> studentsAverages = [];
  List<double> sortedStudentsAverages = [];
  List<List<StatisticsCellValue>> cells = [];

  Completer completer = Completer();
  //
  ExportStudentsStatisticsBloc(this._getMyStudentsResultsUc, this._getAttendanceSetsUsecase, this._getTestsUsecase) : super(ExportStatisticsLoading()) {
    on<InitializeStudentsStatisticsEvent>(onInitializeStudentsStatisticsEvent);
    on<PickTestsEvent>(onPickTestsEvent);
    on<PickSetsEvent>(onPickSetsEvent);
    on<SetTestsEvent>(onSetTestsEvent);
    on<SetSetsEvent>(onSetSetsEvent);
    on<ExportStatisticsExcelEvent>(onExportStatisticsExcelEvent);
    on<ExportStatisticsPdfEvent>(onExportStatisticsPdfEvent);
  }

  ///
  onInitializeStudentsStatisticsEvent(InitializeStudentsStatisticsEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    emit(ExportStatisticsLoading(state: state));
    emit(ExportStatisticsInitial(
      sets: [],
      tests: [],
      selectedSets: [],
      selectedTests: [],
      students: even.students,
    ));
    // final testsResponse = await _getMyStudentsResultsUc.call(students: even.students);
    // await testsResponse.fold(
    //   (failure) {
    //     Fluttertoast.showToast(msg: failure.toString());
    //     emit(ExportStatisticsInitial(
    //       sets: [],
    //       tests: [],
    //       selectedSets: [],
    //       selectedTests: [],
    //       message: failure.toString(),
    //       studentsRows: state.studentsRows,
    //       students: even.students,
    //     ));
    //   },
    //   (response) async {
    //     if (state is ExportStatisticsLoading) {
    //       emit(ExportStatisticsInitial(
    //         sets: [],
    //         tests: response.tests,
    //         selectedSets: [],
    //         selectedTests: [],
    //         studentsRows: response.rows,
    //         students: even.students,
    //       ));
    //     }
    //   },
    // );
  }

  ///
  onPickTestsEvent(PickTestsEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    emit(ExportStatisticsLoading(state: state));
    final testsResponse = await _getTestsUsecase.call(queryIds: true);
    await testsResponse.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.toString());
        emit(ExportStatisticsPickTests(
          sets: state.sets,
          tests: state.tests,
          selectedSets: state.selectedSets,
          selectedTests: state.selectedTests,
          students: state.students,
          message: failure.toString(),
        ));
      },
      (tests) async {
        tests.sort((a, b) => (state.selectedTests.contains((b.id, b.information.title)) ? 1 : 0).compareTo(state.selectedTests.contains((a.id, a.information.title)) ? 1 : 0));
        emit(ExportStatisticsPickTests(
          sets: state.sets,
          tests: tests.map((e) => (e.id, e.information.title)).toList(),
          selectedSets: state.selectedSets,
          selectedTests: state.selectedTests,
          students: state.students,
        ));
      },
    );
  }

  ///
  onPickSetsEvent(PickSetsEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    emit(ExportStatisticsLoading(state: state));
    final setsResponse = await _getAttendanceSetsUsecase.call(isOffline: false);
    await setsResponse.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.toString());
        emit(ExportStatisticsPickSets(
          sets: state.sets,
          tests: state.tests,
          selectedTests: state.selectedTests,
          selectedSets: state.selectedSets,
          message: failure.toString(),
          students: state.students,
        ));
      },
      (sets) async {
        if (state is ExportStatisticsLoading) {
          emit(ExportStatisticsPickSets(
            sets: sets,
            tests: state.tests,
            selectedSets: state.selectedSets,
            selectedTests: state.selectedTests,
            students: state.students,
          ));
        }
      },
    );
  }

  ///
  onSetTestsEvent(SetTestsEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    emit(
      ExportStatisticsInitial(
        sets: state.sets,
        selectedTests: even.selectedTests,
        selectedSets: state.selectedSets,
        tests: state.tests,
        students: state.students,
      ),
    );
  }

  ///
  onSetSetsEvent(SetSetsEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    emit(
      ExportStatisticsInitial(
        sets: state.sets,
        selectedTests: state.selectedTests,
        selectedSets: even.selectedSets,
        tests: state.tests,
        students: state.students,
      ),
    );
  }

  ///
  onExportStatisticsPdfEvent(ExportStatisticsPdfEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    ///
    emit(ExportStatisticsProcessing(
      sets: state.sets,
      tests: state.tests,
      selectedTests: state.selectedTests,
      students: state.students,
      selectedSets: state.selectedSets,
    ));

    ///
    final rows = await getStudentsRows();
    if (rows == null) {
      Fluttertoast.showToast(msg: "حصل خطا ما اثناء الحصول على بيانات الطلاب");
      emit(ExportStatisticsInitial(
        sets: state.sets,
        selectedTests: state.selectedTests,
        selectedSets: state.selectedSets,
        tests: state.tests,
        students: state.students,
        message: "حصل خطا ما اثناء الحصول على بيانات الطلاب",
      ));
      return;
    }
    await exportGroupAttendancePdf(
      rows: rows,
      sets: state.selectedSets,
    );
  }

  ///
  onExportStatisticsExcelEvent(ExportStatisticsExcelEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    ///
    emit(ExportStatisticsProcessing(
      sets: state.sets,
      tests: state.tests,
      selectedTests: state.selectedTests,
      students: state.students,
      selectedSets: state.selectedSets,
    ));

    ///
    final rows = await getStudentsRows();
    if (rows == null) {
      Fluttertoast.showToast(msg: "حصل خطا ما اثناء الحصول على بيانات الطلاب");
      emit(ExportStatisticsInitial(
        sets: state.sets,
        selectedTests: state.selectedTests,
        selectedSets: state.selectedSets,
        tests: state.tests,
        students: state.students,
        message: "حصل خطا ما اثناء الحصول على بيانات الطلاب",
      ));
      return;
    }

    ///
    testsIds = state.selectedTests.map((e) => e.$1).toList();
    setsIds = state.selectedSets.map((e) => e.id).toList();

    ///
    studentsAverages = [];
    sortedStudentsAverages = [];
    cells = [];

    ///
    var excel = Excel.createExcel();
    resultsSheet = excel['Sheet1'];

    /// add header rows
    cells.add(headerRow());

    if (state.selectedTests.isNotEmpty) {
      ///
      for (var row in rows) {
        cells.add(
          row.toExcelRow(
            testsIds: testsIds,
            setsIds: setsIds,
            onGetAverage: ({required double average}) {
              studentsAverages.add(average);
            },
          ),
        );
      }
    } else {
      ///
      for (var row in rows) {
        int studentAbsents = 0;
        for (var set in setsIds) {
          if (!row.records.any((e) => e.attendanceSetId == set.toString())) {
            studentAbsents++;
          }
        }
        cells.add([
          StatisticsCellValue(value: TextCellValue(row.userId.toString().padLeft(6, "0"))),
          StatisticsCellValue(value: TextCellValue(row.name)),
          StatisticsCellValue(value: IntCellValue(studentAbsents)),
          ...List.generate(
            setsIds.length,
            (i) {
              final style = CellStyle(
                numberFormat: NumFormat.standard_2,
                fontColorHex: ExcelColor.red,
              );
              if (row.records.any((e) => e.attendanceSetId == setsIds[i].toString())) {
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
        ]);
      }
    } // 2921 937

    /// insert cells
    for (var cell in cells) {
      resultsSheet!.appendRow(cell.map((e) => e.value).toList());
    }

    /// set cells style
    for (int i = 0; i < cells.length; i++) {
      for (int j = 0; j < cells[i].length; j++) {
        if (cells[i][j].style != null) {
          resultsSheet!.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i)).cellStyle = cells[i][j].style;
        }
      }
    }

    ///
    if (state.selectedTests.isNotEmpty) {
      sortedStudentsAverages = List.from(studentsAverages)..sort((a, b) => b.compareTo(a));
      sortedStudentsAverages = sortedStudentsAverages.toSet().toList();
      await onSetStudentsRate();
    }

    //
    // // Save the file to the local storage
    if (kDebugMode) {
      emit(
        ExportStatisticsInitial(
          sets: state.sets,
          selectedTests: state.selectedTests,
          selectedSets: state.selectedSets,
          tests: state.tests,
          students: state.students,
        ),
      );
      var filePath = await save(excel);
      await OpenFile.open(filePath);
      return;
    }
    emit(ExportStatisticsCompleted(excel));
  }

  ///
  Future<void> onSetStudentsRate() async {
    int length = sortedStudentsAverages.length;
    int groupSize = (length / 5).ceil();

    for (int i = 0; i < studentsAverages.length; i++) {
      double average = studentsAverages[i];
      int index = sortedStudentsAverages.indexOf(average);

      // Calculate which group this student falls into
      String grade = '';
      if (index < groupSize) {
        grade = 'A'; // Top 20%
      } else if (index < groupSize * 2) {
        grade = 'B'; // Second 20%
      } else if (index < groupSize * 3) {
        grade = 'C'; // Third 20%
      } else if (index < groupSize * 4) {
        grade = 'D'; // Fourth 20%
      } else {
        grade = 'F'; // Last 20%
      }

      // Set the grade in the Excel sheet
      resultsSheet!.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1)).value = TextCellValue(grade);
    }
  }

  ///
  List<StatisticsCellValue> headerRow() {
    if (state.selectedTests.isEmpty) {
      return [
        StatisticsCellValue(value: TextCellValue(" رقم الطالب ")),
        StatisticsCellValue(value: TextCellValue(" اسم الطالب ")),
        StatisticsCellValue(value: TextCellValue("  غيابات الجلسات  ")),
        ...state.selectedSets.map((e) {
          return StatisticsCellValue(value: TextCellValue(e.title));
        }),
      ];
    }
    return [
      StatisticsCellValue(value: TextCellValue(" رقم الطالب ")),
      StatisticsCellValue(value: TextCellValue(" اسم الطالب ")),
      StatisticsCellValue(value: TextCellValue("  المحصلة  ")),
      StatisticsCellValue(value: TextCellValue("  تقييم الطالب  ")),
      if (state.selectedTests.isNotEmpty) StatisticsCellValue(value: TextCellValue("  غيابات الاختبارات  ")),
      if (state.selectedSets.isNotEmpty) StatisticsCellValue(value: TextCellValue("  غيابات الجلسات  ")),
      if (state.selectedTests.isNotEmpty)
        ...state.selectedTests.expand((e) => [
              StatisticsCellValue(value: TextCellValue(e.$2)),
              StatisticsCellValue(value: TextCellValue("تاريخ الحل")),
              StatisticsCellValue(value: TextCellValue("مدة الحل")),
            ]),
      if (state.selectedSets.isNotEmpty) ...state.selectedSets.map((e) => StatisticsCellValue(value: TextCellValue(e.title))),
    ];
  }

  ///
  Future<List<StudentRowDetails>?> getStudentsRows() async {
    ///
    final response = await _getMyStudentsResultsUc.call(
      studentsIds: state.students.map((e) => e.uuid).toList(),
      testsIds: state.selectedTests.map((e) => e.$1.toString()).toList(),
      setsIds: state.selectedSets.map((e) => e.id.toString()).toList(),
    );

    if (response.isLeft()) {
      return null;
    }

    ///
    testsIds = state.selectedTests.map((e) => e.$1).toList();
    setsIds = state.selectedSets.map((e) => e.id).toList();
    results = response.fold(
      (failure) {
        return [];
      },
      (results) => results,
    );

    ///
    List<StudentRowDetails> rows = [];

    ///
    for (var student in state.students) {
      ///
      List<StudentTestMarkDetails> marks = [];
      List<AttendanceRecord> records = [];
      List<Result> studentResults = results.where((e) => e.userId == student.uuid).toList();

      ///
      studentResults.sort((a, b) => a.date.compareTo(b.date));

      ///
      for (var test in state.selectedTests) {
        List<Result> studentResultsForTest = studentResults.where((e) => e.testId == test.$1).toList();
        if (studentResultsForTest.isNotEmpty) {
          final result = studentResultsForTest.first;
          marks.add(StudentTestMarkDetails(
            testId: test.$1,
            mark: result.mark,
            date: result.date,
            period: result.period,
          ));
        }
      }

      ///
      for (var set in state.selectedSets) {
        List<Result> studentResultsForSet = studentResults.where((e) => e.outerTestId == set.id).toList();
        if (studentResultsForSet.isNotEmpty) {
          final result = studentResultsForSet.first;
          records.add(AttendanceRecord(
            id: 0,
            attendanceSetId: set.id.toString(),
            studentName: student.name,
            studentId: student.id.toString(),
            date: result.date,
          ));
        }
      }

      ///
      rows.add(StudentRowDetails(
        name: student.name,
        userId: student.id,
        marks: marks,
        records: records,
      ));
    }

    ///
    rows.sort((a, b) => a.userId.compareTo(b.userId));

    ///
    return rows;
  }
}

class StatisticsCellValue {
  final CellValue value;
  final CellStyle? style;

  StatisticsCellValue({
    required this.value,
    this.style,
  });
}
