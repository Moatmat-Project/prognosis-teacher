import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/services/pdf_s.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';

import '../../../../Features/students/domain/entities/result.dart';

class ExportPdfV extends StatefulWidget {
  const ExportPdfV({super.key, required this.results, required this.name});
  final String name;
  final List<Result> results;
  @override
  State<ExportPdfV> createState() => _ExportPdfVState();
}

class _ExportPdfVState extends State<ExportPdfV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تصدير ملف pdf"),
      ),
      body: Column(
        children: [
          ElevatedButtonWidget(
            text: "",
            onPressed: () async {
              await PdfService().exportResults(widget.results, widget.name);
            },
          ),
        ],
      ),
    );
  }
}
