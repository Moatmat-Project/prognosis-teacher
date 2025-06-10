import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/functions/excel/export_attendance_set_excel.dart';
import 'package:moatmat_teacher/Core/functions/pdf/export_attendance_set_pdf.dart';
import 'package:moatmat_teacher/Core/functions/pdf/export_results_pdf.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';

import '../../../Core/widgets/toucheable_tile_widget.dart';

class ExportAttendanceSetView extends StatefulWidget {
  const ExportAttendanceSetView({
    super.key,
    required this.set,
    required this.records,
  });
  final AttendanceSet set;
  final List<AttendanceRecord> records;
  @override
  State<ExportAttendanceSetView> createState() => _ExportAttendanceSetViewState();
}

class _ExportAttendanceSetViewState extends State<ExportAttendanceSetView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تصدير جلسة الحضور"),
      ),
      body: Column(
        children: [
          TouchableTileWidget(
            title: "تصدير بصيغة ملف اكسل",
            onTap: () async {
              await exportAttendanceSetExcel(set: widget.set, records: widget.records);
            },
          ),
          TouchableTileWidget(
            title: "تصدير بصيغة ملف pdf",
            onTap: () async {
              exportAttendanceSetPdf(set: widget.set, records: widget.records);
            },
          ),
        ],
      ),
    );
  }
}
