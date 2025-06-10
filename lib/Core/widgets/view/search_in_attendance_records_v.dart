import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Presentation/attendance/views/set_up_attendance_view.dart';
import '../../../Presentation/attendance/widgets/attendance_record_tile_widget.dart';
import '../toucheable_tile_widget.dart';

class SearchInAttendanceRecordsView extends StatefulWidget {
  const SearchInAttendanceRecordsView({
    super.key,
    required this.records,
  });
  final List<AttendanceRecord> records;
  @override
  State<SearchInAttendanceRecordsView> createState() => _SearchInAttendanceRecordsViewState();
}

class _SearchInAttendanceRecordsViewState extends State<SearchInAttendanceRecordsView> {
  late TextEditingController _controller;
  List<AttendanceRecord> records = [];
  List<AttendanceRecord> search = [];
  @override
  void initState() {
    records = widget.records;
    //
    search = widget.records;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = records;
      } else {
        search = records.where((e) {
          return e.studentName.contains(_controller.text);
        }).toList();
      }
      setState(() {});
    });
    //
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            controller: _controller,
          ),
          //
          const SizedBox(height: SizesResources.s2),
          //
          Expanded(
            child: ListView.builder(
              itemCount: search.length,
              itemBuilder: (context, index) {
                return AttendanceRecordTileWidget(
                  record: search[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
