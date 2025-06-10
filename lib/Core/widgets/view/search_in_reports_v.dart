import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Presentation/students/state/student_reports/student_reports_cubit.dart';
import '../toucheable_tile_widget.dart';

class SearchInReportsView extends StatefulWidget {
  const SearchInReportsView({
    super.key,
    required this.reports,
    required this.onPick,
  });
  final List<ReportItem> reports;
  final void Function(ReportItem test) onPick;
  @override
  State<SearchInReportsView> createState() => _SearchInReportsViewState();
}

class _SearchInReportsViewState extends State<SearchInReportsView> {
  late TextEditingController _controller;
  List<ReportItem> reports = [];
  List<ReportItem> search = [];
  @override
  void initState() {
    reports = widget.reports;
    //
    search = widget.reports;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = reports;
      } else {
        search = reports.where((e) {
          return e.title.contains(_controller.text);
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
                return TouchableTileWidget(
                  title: search[index].title,
                  onTap: () {
                    widget.onPick(search[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
