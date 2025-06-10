import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_results_v.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Presentation/scanner/state/cubit/explore_outer_tests_cubit.dart';
import 'package:moatmat_teacher/Presentation/tests/views/outer_test_details_v.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../export/views/results/choose_export_v.dart';
import '../../students/views/student_v.dart';
import '../../students/widgets/result_tile_w.dart';
import '../../tests/widgets/outer_test_tile_w.dart';

class ExploreOuterTestsView extends StatefulWidget {
  const ExploreOuterTestsView({super.key});

  @override
  State<ExploreOuterTestsView> createState() => _ExploreOuterTestsViewState();
}

class _ExploreOuterTestsViewState extends State<ExploreOuterTestsView> {
  @override
  void initState() {
    context.read<ExploreOuterTestsCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExploreOuterTestsCubit, ExploreOuterTestsState>(
        builder: (context, state) {
          if (state is ExploreOuterTestsInitial) {
            return ListView.builder(
              itemCount: state.tests.length,
              itemBuilder: (context, index) {
                return OuterTestTileWidget(
                  test: state.tests[index],
                  onPick: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OUterTestDetailsView(
                          test: state.tests[index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
