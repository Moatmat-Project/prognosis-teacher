import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Presentation/export/views/results/export_excel_v.dart';
import 'package:moatmat_teacher/Presentation/export/views/results/export_pdf_v.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Core/resources/sizes_resources.dart';
import '../../../../Core/services/pdf_s.dart';
import '../../../../Core/widgets/fields/drop_down_w.dart';
import '../../../../Features/students/domain/entities/result.dart';

class ChooseExportV extends StatefulWidget {
  const ChooseExportV({super.key, required this.results, required this.name});
  final String name;
  final List<Result> results;

  @override
  State<ChooseExportV> createState() => _ChooseExportVState();
}

class _ChooseExportVState extends State<ChooseExportV> {
  bool filter = false;
  //
  late List<Result> results;
  //

  List<String> types = [
    "جميع العلامات",
    "اعلى علامة",
  ];
  @override
  void initState() {
    results = widget.results;
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لا يوجد نتائج لتصديرها")));
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  onExportExcel() async {
    // Create an Excel document
    var excel = Excel.createExcel();

    // Access the sheet named 'resultsSheet'
    Sheet resultsSheet = excel['Sheet1'];
    // Populate the sheet with data
    resultsSheet.appendRow([
      // 1 - id
      ( TextCellValue("رقم الطالب")),
      // 2 - name
      ( TextCellValue("اسم الطالب")),
      // 3 - mark
      ( TextCellValue("العلامة")),
      // 4 - test id
      ( TextCellValue("رقم البنك")),
      // 5 - bank id
      ( TextCellValue("رقم الاختبار")),
      // 6 - wrong answers
      ( TextCellValue("الاجابات الخاطئة")),
      // 7 - date
      ( TextCellValue("التاديخ")),
      // 8 - time
      ( TextCellValue("الوقت")),
      // 9 - period
      ( TextCellValue("المدة")),
      // 10 - t/b name
      ( TextCellValue("الاسم")),
      //
    ]);
    // Example headers
    for (var result in results) {
      resultsSheet.appendRow(result.toExcelRow());
    }
    //
    // Save the file to the local storage
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/results_of_${widget.name.replaceAll(" ", "_")}.xlsx';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تصدير النتائج"),
      ),
      body: Column(
        children: [
          TouchableTileWidget(
            title: "تصدير بصيغة ملف اكسل",
            onTap: () async {
              try {
                onFilter();
                onExportExcel();
              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('error : $e')),
                );
              }
            },
          ),
          TouchableTileWidget(
            title: "تصدير بصيغة ملف pdf",
            onTap: () async {
              try {
                onFilter();
                await PdfService().exportResults(widget.results, widget.name);
              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('error : $e')),
                );
              }
            },
          ),
          const SizedBox(height: SizesResources.s2),
          DropDownWidget(
            hintText: "نوع التصدير ",
            selectedItem: types.first,
            items: types,
            onSaved: (p0) {},
            onChanged: (p0) {
              setState(() {
                filter = (p0 == types[1]);
              });
            },
          ),
        ],
      ),
    );
  }

  onFilter() {
    print(1);

    ///
    if (!filter) {
      results = widget.results;
      print(2);
      return;
    }

    ///
    List<Result> newResults = [];

    ///
    Map<String, Result> data = {};

    ///
    for (var r in widget.results) {
      //
      String key = r.userName + r.testName;
      //
      if (data[key] == null) {
        data[key] = r;
      }
      //
      if (data[key]!.mark < r.mark) {
        data[key] = r;
      }
    }

    ///
    data.forEach((key, value) {
      newResults.add(value);
    });

    ///
    results = newResults;
  }
}
