import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/math/calculate_mark_f.dart';
import 'package:moatmat_teacher/Core/functions/math/mark_to_latter_f.dart';
import 'package:moatmat_teacher/Core/functions/parsers/period_to_text_f.dart';
import 'package:moatmat_teacher/Core/functions/parsers/time_to_text_f.dart';
import 'package:moatmat_teacher/Core/widgets/repository_details_item.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_results_v.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/tests_results/views/answers_percentage_v.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../export/views/results/choose_export_v.dart';
import '../../students/views/student_v.dart';
import '../state/cubit/test_results_cubit.dart';

class TestResultsView extends StatefulWidget {
  const TestResultsView({super.key, required this.test});
  final Test test;
  @override
  State<TestResultsView> createState() => _TestResultsViewState();
}

class _TestResultsViewState extends State<TestResultsView> {
  @override
  void initState() {
    context.read<TestResultsCubit>().init(widget.test);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TestResultsCubit, TestResultsState>(
        builder: (context, state) {
          if (state is TestResultsInitial) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "نتائج ${widget.test.information.title}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                actions: [
                  //
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChooseExportV(
                            name: widget.test.information.title,
                            results: state.details.marks.map((e) => e.$1).toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_open_sharp),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchInResultsView(
                            results: state.details.marks.map((e) {
                              return e.$1;
                            }).toList(),
                            onPick: (r) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StudentView(
                                    userName: r.userName,
                                    userId: r.userId,
                                    result: r,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<TestResultsCubit>().update();
                  return;
                },
                child: Column(
                  children: [
                    RepositoryDetailsItemWidget(
                      averageMark: "%${state.details.averageMark * 100}",
                      averageTime: ((state.details.averageTime)).toInt(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TestAnswersPercentage(
                              details: state.details,
                              test: widget.test,
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 5 / 3,
                          crossAxisSpacing: SizesResources.s2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: SizesResources.s2,
                        ),
                        itemCount: state.details.marks.length,
                        itemBuilder: (context, index) {
                          //
                          return MarkInfoItemWidget(
                            //
                            name: state.details.marks[index].$1.userName,
                            //
                            markLetter: markToLatterFunction(
                              state.details.getMarkPercentage(
                                state.details.marks[index].$1.mark,
                              ),
                            ),
                            mark: "%${state.details.marks[index].$1.mark}",
                            //
                            time: periodToTextFunction(
                              state.details.marks[index].$1.period,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StudentView(
                                    userName: state.details.marks[index].$1.userName,
                                    userId: state.details.marks[index].$1.userId,
                                    result: state.details.marks[index].$1,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class MarkInfoItemWidget extends StatelessWidget {
  const MarkInfoItemWidget({
    super.key,
    required this.name,
    required this.mark,
    required this.markLetter,
    required this.time,
    required this.onTap,
  });
  final String name, mark, markLetter, time;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainHalfWidth(context),
      margin: const EdgeInsets.symmetric(
        vertical: SizesResources.s1,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: ShadowsResources.mainBoxShadow,
        border: markLetter == ''
            ? Border.all(
                color: ColorsResources.red,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SizesResources.s3,
              vertical: SizesResources.s3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: SizesResources.s2),
                      FittedBox(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        mark,
                        style: const TextStyle(
                          color: ColorsResources.blackText2,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: ColorsResources.blackText2,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SizesResources.s2),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      markLetter,
                      style: const TextStyle(
                        fontSize: 32,
                        color: ColorsResources.darkPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: SizesResources.s2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
