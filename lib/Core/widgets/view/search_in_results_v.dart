import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moatmat_teacher/Core/functions/math/mark_to_latter_f.dart';
import 'package:moatmat_teacher/Core/functions/parsers/time_to_text_f.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';

import '../toucheable_tile_widget.dart';

class SearchInResultsView extends StatefulWidget {
  const SearchInResultsView({
    super.key,
    required this.results,
    required this.onPick,
  });
  final List<Result> results;
  final void Function(Result result) onPick;
  @override
  State<SearchInResultsView> createState() => _SearchInResultsViewState();
}

class _SearchInResultsViewState extends State<SearchInResultsView> {
  late TextEditingController _controller;
  List<Result> results = [];
  List<Result> search = [];
  @override
  void initState() {
    results = widget.results;
    //
    search = widget.results;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = results;
      } else {
        search = results.where((e) {
          return e.userName.contains(_controller.text);
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
                  title: search[index].userName,
                  subTitle: timeToText(search[index].date),
                  icon: Text(markToLatterFunction(search[index].mark)),
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
