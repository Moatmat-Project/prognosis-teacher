import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/functions/pdf/export_results_pdf.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import '../../../../Core/functions/excel/export_results_excel.dart';
import '../../../../Core/resources/sizes_resources.dart';
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
    "أعلى علامة",
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
                await onFilter();
                exportResultsExcel(name: widget.name, results: results);
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
                await onFilter();
                //156778
                await exportResultsPdf(results.reversed.toList(), widget.name);
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
    ///
    if (!filter) {
      results = widget.results;
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
