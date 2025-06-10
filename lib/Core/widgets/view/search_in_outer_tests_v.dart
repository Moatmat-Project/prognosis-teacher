import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import '../../../Presentation/scanner/state/cubit/explore_outer_tests_cubit.dart';
import '../toucheable_tile_widget.dart';

class SearchInOuterTestsView extends StatefulWidget {
  const SearchInOuterTestsView({
    super.key,
    required this.onPick,
  });

  final void Function(OuterTest test) onPick;
  @override
  State<SearchInOuterTestsView> createState() => _SearchInOuterTestsViewState();
}

class _SearchInOuterTestsViewState extends State<SearchInOuterTestsView> {
  late TextEditingController _controller;
  List<OuterTest> tests = [];
  List<OuterTest> search = [];
  @override
  void initState() {
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
      body: BlocBuilder<ExploreOuterTestsCubit, ExploreOuterTestsState>(
        builder: (context, state) {
          if (state is ExploreOuterTestsInitial) {
            tests = state.tests;
            search = state.tests;
            return Column(
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
                          Navigator.of(context).pop();
                          widget.onPick(search[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
