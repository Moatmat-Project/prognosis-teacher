import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Presentation/students/widgets/result_tile_w.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Features/students/domain/entities/result.dart';

class ExportExcelV extends StatefulWidget {
  const ExportExcelV({
    super.key,
    required this.results,
    required this.name,
  });
  final String name;
  final List<Result> results;
  @override
  State<ExportExcelV> createState() => _ExportExcelVState();
}

class _ExportExcelVState extends State<ExportExcelV> {
  onExport() async {
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
    for (var result in widget.results) {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel file saved to $filePath')),
    );
    await Share.shareXFiles(
      [XFile(filePath)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تصدير ملف اكسل"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: widget.results.length,
              itemBuilder: (context, index) {
                return ResultTileWidget(
                  result: widget.results[index],
                );
              },
            )),
            ElevatedButtonWidget(
              text: "تصدير و حفظ",
              onPressed: () {
                onExport();
              },
            ),
            const SizedBox(height: SizesResources.s10),
          ],
        ),
      ),
    );
  }
}
