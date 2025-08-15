import 'dart:io';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/images_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Core/widgets/fields/text_input_field.dart';
import '../state/bloc/export_students_statistics_bloc.dart';

class ExportStudentsStatisticsView extends StatefulWidget {
  const ExportStudentsStatisticsView({super.key, required this.students});
  final List<UserData> students;
  @override
  State<ExportStudentsStatisticsView> createState() => _ExportStudentsStatisticsViewState();
}

class _ExportStudentsStatisticsViewState extends State<ExportStudentsStatisticsView> {
  @override
  void initState() {
    locator<ExportStudentsStatisticsBloc>().add(InitializeStudentsStatisticsEvent(widget.students));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<ExportStudentsStatisticsBloc>(),
      child: BlocConsumer<ExportStudentsStatisticsBloc, ExportStudentsStatisticsState>(
        listener: (context, state) {
          if (state.message != null) {
            Fluttertoast.showToast(msg: state.message!);
          }
        },
        builder: (context, state) {
          if (state is ExportStatisticsPickTests) {
            return ExportStatisticsPickTestsView(state: state);
          } else if (state is ExportStatisticsInitial) {
            return ExportStatisticsInitialView(state: state);
          } else if (state is ExportStatisticsPickSets) {
            return ExportStatisticsPickSetsView(state: state);
          } else if (state is ExportStatisticsProcessing) {
            return ExportStatisticsProcessingView(state: state);
          } else if (state is ExportStatisticsCompleted) {
            return ExportStatisticsCompletedView(state: state);
          } else if (state is ExportStatisticsLoading) {
            return ExportStatisticsLoadingView();
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  locator<ExportStudentsStatisticsBloc>().add(SetSetsEvent(state.selectedSets));
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class ExportStatisticsInitialView extends StatelessWidget {
  const ExportStatisticsInitialView({super.key, required this.state});
  final ExportStatisticsInitial state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تصدير حضور الطلاب"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizesResources.s4,
              ),
              Material(
                color: ColorsResources.green.withAlpha(100),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    locator<ExportStudentsStatisticsBloc>().add(PickTestsEvent());
                  },
                  child: Container(
                    width: SpacingResources.mainWidth(context),
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorsResources.green,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "تحديد الاختبارات (${state.selectedTests.length})",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: ColorsResources.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizesResources.s4,
              ),
              Material(
                color: Colors.cyan.withAlpha(100),
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    locator<ExportStudentsStatisticsBloc>().add(PickSetsEvent());
                  },
                  child: Container(
                    width: SpacingResources.mainWidth(context),
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "تحديد الجلسات (${state.selectedSets.length})",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              ElevatedButtonWidget(
                onPressed: (state.selectedTests.isNotEmpty || state.selectedSets.isNotEmpty)
                    ? () {
                        locator<ExportStudentsStatisticsBloc>().add(ExportStatisticsExcelEvent());
                      }
                    : null,
                text: "تصدير EXCEL",
              ),
              SizedBox(height: SizesResources.s2),
              ElevatedButtonWidget(
                onPressed: (state.selectedSets.isNotEmpty)
                    ? () {
                        locator<ExportStudentsStatisticsBloc>().add(ExportStatisticsPdfEvent());
                      }
                    : null,
                text: "تصدير PDF (جلسات فقط)",
              ),
              SizedBox(height: SizesResources.s2),
            ],
          ),
        ),
      ),
    );
  }
}

class ExportStatisticsPickTestsView extends StatefulWidget {
  const ExportStatisticsPickTestsView({super.key, required this.state});
  final ExportStatisticsPickTests state;

  @override
  State<ExportStatisticsPickTestsView> createState() => _ExportStatisticsPickTestsViewState();
}

class _ExportStatisticsPickTestsViewState extends State<ExportStatisticsPickTestsView> {
  //
  late List<(int, String)> tests;
  late List<(int, String)> search;
  late List<(int, String)> selectedTests;
  //
  late TextEditingController _controller;
  //
  @override
  void initState() {
    selectedTests = List.from(widget.state.selectedTests);
    tests = widget.state.tests;
    //
    search = widget.state.tests;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("تحديد الاختبارات"),
        leading: IconButton(
          onPressed: () {
            locator<ExportStudentsStatisticsBloc>().add(SetTestsEvent(widget.state.selectedTests));
          },
          icon: Icon(Icons.arrow_back_ios),
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
            maxLines: 1,
            minLines: 1,
            textInputAction: TextInputAction.done,
          ),
          //
          const SizedBox(height: SizesResources.s2),
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
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + SizesResources.s2,
            ),
            child: ElevatedButtonWidget(
              onPressed: () => locator<ExportStudentsStatisticsBloc>().add(
                SetTestsEvent(selectedTests),
              ),
              text: "تحديد ${selectedTests.length} اختبار",
            ),
          ),
        ],
      ),
    );
  }
}

class ExportStatisticsPickSetsView extends StatefulWidget {
  const ExportStatisticsPickSetsView({super.key, required this.state});
  final ExportStatisticsPickSets state;

  @override
  State<ExportStatisticsPickSetsView> createState() => _ExportStatisticsPickSetsViewState();
}

class _ExportStatisticsPickSetsViewState extends State<ExportStatisticsPickSetsView> {
  late List<AttendanceSet> sets;
  late List<AttendanceSet> search;
  late List<AttendanceSet> selectedSets;
  late TextEditingController _controller;
  @override
  void initState() {
    //
    sets = widget.state.sets;
    search = widget.state.sets;
    selectedSets = widget.state.selectedSets;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = sets;
      } else {
        search = sets.where((e) {
          return e.title.contains(_controller.text);
        }).toList();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تحديد الجلسات"),
        leading: IconButton(
          onPressed: () {
            locator<ExportStudentsStatisticsBloc>().add(SetSetsEvent(widget.state.selectedSets));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [],
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButtonWidget(
          onPressed: () => locator<ExportStudentsStatisticsBloc>().add(SetSetsEvent(selectedSets)),
          text: "تحديد ${selectedSets.length} جلسة",
        ),
      )),
      body: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            hintText: "البحث عن جلسة",
            controller: _controller,
          ),
          //
          Expanded(
            child: ListView.builder(
              itemCount: search.length,
              itemBuilder: (context, index) {
                final selected = selectedSets.any((e) => e.id == search[index].id);
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
                          if (!selected) {
                            selectedSets.add(search[index]);
                          } else {
                            selectedSets.removeWhere((e) => e.id == search[index].id);
                          }
                          setState(() {
                            selectedSets;
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
                                    search[index].title,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: selected,
                                onChanged: (value) {
                                  if (value ?? false) {
                                    selectedSets.add(search[index]);
                                  } else {
                                    selectedSets.removeWhere((e) => e.id == search[index].id);
                                  }
                                  setState(() {
                                    selectedSets;
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

class ExportStatisticsProcessingView extends StatelessWidget {
  const ExportStatisticsProcessingView({super.key, required this.state});
  final ExportStatisticsProcessing state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(
              height: SizesResources.s6,
            ),
            Text("جاري المعالجة"),
            SizedBox(
              height: SizesResources.s10,
            ),
          ],
        ),
      ),
    );
  }
}

class ExportStatisticsLoadingView extends StatelessWidget {
  const ExportStatisticsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

class ExportStatisticsCompletedView extends StatelessWidget {
  const ExportStatisticsCompletedView({super.key, required this.state});
  final ExportStatisticsCompleted state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              Image.asset(
                ImagesResources.sheetIcon,
                width: 100,
              ),
              SizedBox(height: SizesResources.s6),
              Text(
                "تم تصدير الحضور بنجاح ",
                style: TextStyle(
                  fontSize: 24,
                  color: ColorsResources.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  open(state.excel);
                },
                label: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    "عرض",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                ),
                icon: Icon(Icons.remove_red_eye),
              ),
              SizedBox(height: SizesResources.s2),
              ElevatedButton.icon(
                onPressed: () {
                  share(state.excel);
                },
                label: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    "مشاركة",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                ),
                icon: Icon(Icons.share),
              ),
              SizedBox(height: SizesResources.s2),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> save(excel.Excel excel) async {
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/statistics_of_students_${DateTime.now().toString().replaceAll(" ", "_").replaceAll("-", "_")}.xlsx';
  var fileBytes = excel.save();
  if (fileBytes != null) {
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }
  return filePath;
}

Future<void> share(excel.Excel excel) async {
  var filePath = await save(excel);
  await Share.shareXFiles([XFile(filePath)]);
}

Future<void> open(excel.Excel excel) async {
  var filePath = await save(excel);
  await OpenFile.open(filePath);
}
