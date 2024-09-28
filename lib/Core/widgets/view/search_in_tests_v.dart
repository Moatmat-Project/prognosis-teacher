import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import '../toucheable_tile_widget.dart';

class SearchInTestsView extends StatefulWidget {
  const SearchInTestsView({
    super.key,
    required this.tests,
    required this.onPick,
  });
  final List<Test> tests;
  final void Function(Test test) onPick;
  @override
  State<SearchInTestsView> createState() => _SearchInTestsViewState();
}

class _SearchInTestsViewState extends State<SearchInTestsView> {
  late TextEditingController _controller;
  List<Test> tests = [];
  List<Test> search = [];
  @override
  void initState() {
    tests = widget.tests;
    //
    search = widget.tests;
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = tests;
      } else {
        search = tests.where((e) {
          return e.information.title.contains(_controller.text);
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
                  title: search[index].information.title,
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
