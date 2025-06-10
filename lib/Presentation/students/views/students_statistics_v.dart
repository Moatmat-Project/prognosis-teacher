import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_repository_students_uc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../../Features/students/data/responses/get_my_students_statistics_response.dart';
import '../../../Features/students/domain/usecases/get_my_students_statistics_uc.dart';

class StudentsStatisticsView extends StatefulWidget {
  ///
  const StudentsStatisticsView({
    super.key,
    required this.students,
  });

  ///
  final List<UserData> students;
  @override
  State<StudentsStatisticsView> createState() => _StudentsStatisticsViewState();
}

class _StudentsStatisticsViewState extends State<StudentsStatisticsView> {
  bool _isLoading = true;
  GetMyStudentsStatisticsResponse? _getMyStudentsStatisticsResponse;
  @override
  void initState() {
    loadStatistics();
    super.initState();
  }

  loadStatistics() async {
    setState(() => _isLoading = true);
    final response = await locator<GetMyStudentsStatisticsUc>().call(
      students: widget.students,
    );
    response.fold(
      (l) {
        Fluttertoast.showToast(msg: l.toString());
        _getMyStudentsStatisticsResponse = null;
      },
      (r) {
        _getMyStudentsStatisticsResponse = r;
      },
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("احصائيات الطلاب"),
      ),
      body: !_isLoading || _getMyStudentsStatisticsResponse != null
          ? _ContentBuilderWidget(
              response: _getMyStudentsStatisticsResponse!,
            )
          : Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}

class _ContentBuilderWidget extends StatefulWidget {
  const _ContentBuilderWidget({super.key, required this.response});
  final GetMyStudentsStatisticsResponse response;
  @override
  State<_ContentBuilderWidget> createState() => _ContentBuilderWidgetState();
}

class _ContentBuilderWidgetState extends State<_ContentBuilderWidget> {
  late List<double> sortedStudentsAverages;
  late List<(int, String)> tests;
  late List<(int, String)> search;
  late List<(int, String)> selectedTests;
  late List<double> studentsAverages;
  late TextEditingController _controller;
  String keyword = "";
  Sheet? resultsSheet;
  Completer completer = Completer();
  @override
  void initState() {
    selectedTests = [];
    studentsAverages = [];
    tests = widget.response.tests;
    //
    search = widget.response.tests;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = tests;
      } else {
        search = tests.where((e) {
          return e.$2.contains(_controller.text);
        }).toList();
      }
      setState(() {});
    });
    super.initState();
  }

  onExport() async {
    //
    completer = Completer();
    //
    List<int> testsIds = selectedTests.map((e) => e.$1).toList();
    // Create an Excel document
    var excel = Excel.createExcel();

    // Access the sheet named 'resultsSheet'
    resultsSheet = excel['Sheet1'];

    // Populate the sheet with data
    resultsSheet!.appendRow([
      // 1 - id
      (TextCellValue(" رقم الطالب ")),
      // 2 - name
      (TextCellValue(" اسم الطالب ")),
      // 3 - average
      (TextCellValue("  المحصلة  ")),
      // 4 - rate
      (TextCellValue("  تقييم الطالب  ")),
      // 5 - absents
      (TextCellValue("  الغيابات  ")),
      // 6 - marks
      ...selectedTests.map((e) => TextCellValue(e.$2)),
      //
    ]);
    //
    resultsSheet!.setColumnWidth(0, 8);
    resultsSheet!.setColumnWidth(1, 25);
    resultsSheet!.setColumnWidth(2, 7);
    resultsSheet!.setColumnWidth(3, 10);
    resultsSheet!.setColumnWidth(4, 8);
    for (int i = 0; i < selectedTests.length; i++) {
      resultsSheet!.setColumnWidth(5 + i, 20);
    }

    // Example headers
    // for (int i = 0; i < widget.response.rows.length; i++) {
    //   resultsSheet!.appendRow(
    //     widget.response.rows[i].toExcelRow(
    //       id: i,
    //       testsIds: testsIds,
    //       onChangeStyle: onChangeStyle,
    //       onGetAverage: ({required double average}) {
    //         studentsAverages.add(average);
    //       },
    //     ),
    //   );
    // }
    sortedStudentsAverages = List.from(studentsAverages)..sort((a, b) => b.compareTo(a));
    sortedStudentsAverages = sortedStudentsAverages.toSet().toList();
    await onSetStudentsRate();
    completer.complete();
    //
    // Save the file to the local storage
    await saveAndShare(excel);
  }

  Future<void> saveAndShare(Excel excel) async {
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/statistics_of_students_${DateTime.now().toString().replaceAll(" ", "_").replaceAll("-", "_")}.xlsx';
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
    await OpenFile.open(filePath);
    // await Share.shareXFiles(
    //   [XFile(filePath)],
    // );
  }

  Future<void> onChangeStyle({
    required int cIndex,
    required int rIndex,
    required CellStyle style,
  }) async {
    await completer.future;
    resultsSheet!.cell(CellIndex.indexByColumnRow(columnIndex: cIndex, rowIndex: rIndex)).cellStyle = style;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              onPressed: selectedTests.isEmpty
                  ? null
                  : () {
                      onExport();
                    },
              text: "تصدير احصائيات ${selectedTests.length} اختبار",
            )
          ],
        ),
      ),
      body: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            hintText: "البحث عن اختبار",
            controller: _controller,
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          Expanded(
            child: ListView.builder(
              itemCount: search.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            if (!selectedTests.contains(search[index])) {
                              selectedTests.add(search[index]);
                            } else {
                              selectedTests.removeWhere((e) => e.$1 == search[index].$1);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    search[index].$2,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: selectedTests.any((e) => e.$1 == search[index].$1),
                                onChanged: (value) {
                                  setState(() {
                                    if (value ?? false) {
                                      selectedTests.add(search[index]);
                                    } else {
                                      selectedTests.removeWhere((e) => e.$1 == search[index].$1);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
