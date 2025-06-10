import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:moatmat_teacher/Core/functions/pdf/export_attendance_set_pdf.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/attendance/domain/usecases/get_attendance_sets_uc.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_my_students_statistics_uc.dart';
import '../../../../Core/functions/pdf/export_group_attendance_pdf.dart';
import '../../../../Features/students/data/responses/get_my_students_statistics_response.dart';
part 'export_students_statistics_event.dart';
part 'export_students_statistics_state.dart';

class ExportStudentsStatisticsBloc extends Bloc<ExportStudentsStatisticsEvent, ExportStudentsStatisticsState> {
  //
  final GetMyStudentsStatisticsUc _getMyStudentsStatisticsUc;
  final GetAttendanceSetsUsecase _getAttendanceSetsUsecase;
  //
  Sheet? resultsSheet;
  List<int> testsIds = [], setsIds = [];

  List<double> studentsAverages = [];
  List<double> sortedStudentsAverages = [];
  List<List<StatisticsCellValue>> cells = [];

  Completer completer = Completer();
  //
  ExportStudentsStatisticsBloc(this._getMyStudentsStatisticsUc, this._getAttendanceSetsUsecase) : super(ExportStatisticsLoading()) {
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
    final testsResponse = await _getMyStudentsStatisticsUc.call(students: even.students);
    await testsResponse.fold(
      (failure) {
        emit(ExportStatisticsInitial(
          sets: [],
          tests: [],
          selectedSets: [],
          selectedTests: [],
          message: failure.toString(),
          studentsRows: state.studentsRows,
          students: even.students,
        ));
      },
      (response) async {
        if (state is ExportStatisticsLoading) {
          emit(ExportStatisticsInitial(
            sets: [],
            tests: response.tests,
            selectedSets: [],
            selectedTests: [],
            studentsRows: response.rows,
            students: even.students,
          ));
        }
      },
    );
  }

  ///
  onPickTestsEvent(PickTestsEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    if (state.tests.isNotEmpty) {
      emit(ExportStatisticsPickTests(
        sets: state.sets,
        tests: state.tests,
        selectedSets: state.selectedSets,
        selectedTests: state.selectedTests,
        studentsRows: state.studentsRows,
        students: state.students,
      ));
      return;
    }
    emit(ExportStatisticsLoading(state: state));
    final testsResponse = await _getMyStudentsStatisticsUc.call(students: state.students);
    await testsResponse.fold(
      (failure) {
        emit(ExportStatisticsPickTests(
          sets: state.sets,
          tests: state.tests,
          selectedSets: state.selectedSets,
          selectedTests: state.selectedTests,
          message: failure.toString(),
          studentsRows: state.studentsRows,
          students: state.students,
        ));
      },
      (response) async {
        if (state is ExportStatisticsLoading) {
          emit(ExportStatisticsPickTests(
            sets: state.sets,
            tests: response.tests,
            selectedSets: state.selectedSets,
            selectedTests: state.selectedTests,
            studentsRows: response.rows,
            students: state.students,
          ));
        }
      },
    );
  }

  ///
  onPickSetsEvent(PickSetsEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    if (state.sets.isNotEmpty) {
      emit(ExportStatisticsPickSets(
        sets: state.sets,
        tests: state.tests,
        studentsRows: state.studentsRows,
        selectedSets: state.selectedSets,
        selectedTests: state.selectedTests,
        students: state.students,
      ));
      return;
    }
    emit(ExportStatisticsLoading(state: state));
    final setsResponse = await _getAttendanceSetsUsecase.call();
    await setsResponse.fold(
      (failure) {
        emit(ExportStatisticsPickSets(
          sets: state.sets,
          tests: state.tests,
          selectedTests: state.selectedTests,
          selectedSets: state.selectedSets,
          studentsRows: state.studentsRows,
          message: failure.toString(),
          students: state.students,
        ));
      },
      (sets) async {
        if (state is ExportStatisticsLoading) {
          emit(ExportStatisticsPickSets(
            sets: sets,
            tests: state.tests,
            studentsRows: state.studentsRows,
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
        studentsRows: state.studentsRows,
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
        studentsRows: state.studentsRows,
        students: state.students,
      ),
    );
  }

  onExportStatisticsPdfEvent(ExportStatisticsPdfEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    await exportGroupAttendancePdf(
      rows: state.studentsRows,
      sets: state.selectedSets,
    );
  }

  onExportStatisticsExcelEvent(ExportStatisticsExcelEvent even, Emitter<ExportStudentsStatisticsState> emit) async {
    ///
    emit(ExportStatisticsProcessing(
      sets: state.sets,
      tests: state.tests,
      studentsRows: state.studentsRows,
      selectedTests: state.selectedTests,
      students: state.students,
      selectedSets: state.selectedSets,
    ));

    ///
    testsIds = state.selectedTests.map((e) => e.$1).toList();
    setsIds = state.selectedSets.map((e) => e.id).toList();
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
      for (var row in state.studentsRows) {
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
      for (var row in state.studentsRows) {
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
    }

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
    emit(ExportStatisticsCompleted(excel));
  }

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
      if (state.selectedTests.isNotEmpty) ...state.selectedTests.map((e) => StatisticsCellValue(value: TextCellValue(e.$2))),
      if (state.selectedSets.isNotEmpty) ...state.selectedSets.map((e) => StatisticsCellValue(value: TextCellValue(e.title))),
    ];
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
