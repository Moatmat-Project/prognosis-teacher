import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/usecases/upload_results_uc.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/add_results_uc.dart';
import 'dart:io';

import 'package:moatmat_teacher/Presentation/students/widgets/result_tile_w.dart';

class AddResultsView extends StatefulWidget {
  const AddResultsView({super.key});

  @override
  State<AddResultsView> createState() => _AddResultsViewState();
}

class _AddResultsViewState extends State<AddResultsView> {
  bool isLoading = false;
  String? filePath, email;
  List<Result> _results = [];

  void readExcelFile(String path) async {
    //
    setState(() {
      isLoading = true;
    });
    //
    _results = [];
    //
    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<Result> results = [];

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet != null) {
        int oucnter = 0;
        for (var row in sheet.rows.skip(1)) {
          oucnter++;
          print(oucnter);
          print(row[2]?.value);
          results.add(Result(
            id: 0,
            userId: "",
            testId: null,
            bankId: null,
            form: null,
            outerTestId: null,
            testName: (row[0]?.value as TextCellValue?)?.value.toString() ?? "",
            userName: (row[1]?.value as TextCellValue?)?.value.toString() ?? "",
            mark: ((row[2]?.value as IntCellValue?)?.value ?? 0).toDouble(),
            date: DateTime.tryParse((row[3]?.value as DateCellValue?)?.asDateTimeLocal().toString() ?? "") ?? DateTime.now(),
            userNumber: (row[4]?.value as IntCellValue?)?.value.toString() ?? "",
            answers: [],
            wrongAnswers: [],
            period: 0,
          ));
        }
      }
    }
    setState(() {
      isLoading = false;
      _results = results;
    });
  }

  uploadResults() async {
    setState(() {
      isLoading = true;
    });
    final response = await locator<AddResultsUC>().call(
      results: _results.map((e) => e.copyWith(teacherEmail: email ?? locator<TeacherData>().email)).toList(),
    );
    response.fold(
      (l) {
        Fluttertoast.showToast(msg: "حصل خطا ما اثناء محاولة رفع النتائج ، تفاصيل الخطا : $l");
      },
      (r) async {
        await Fluttertoast.showToast(msg: "تم رفع النتائج بنجاح");
        Navigator.of(context).pop();
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              loading: isLoading,
              onPressed: () async {
                if (filePath == null) {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['xlsx'],
                  );
                  if (result != null) {
                    filePath = result.files.single.path;
                    if (filePath != null) {
                      readExcelFile(filePath!);
                    }
                  }
                } else {
                  await uploadResults();
                }
              },
              text: filePath == null ? ("اختيار ملف اكسل") : ("رفع النتائج"),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            if (filePath != null) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return ResultTileWidget(
                      result: _results[index],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
