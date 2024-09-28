import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/widgets/repository_details_item.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/banks_results/views/answers_percentage_v.dart';
import 'package:moatmat_teacher/Presentation/groups/state/group_test_detials/group_test_details_cubit.dart';
import 'package:moatmat_teacher/Presentation/tests_results/views/answers_percentage_v.dart';

import '../../../Core/functions/math/mark_to_latter_f.dart';
import '../../../Core/functions/parsers/period_to_text_f.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/groups/domain/entities/group.dart';
import '../../outer_tests_results/views/answers_percentage_v.dart';
import '../../students/views/student_v.dart';
import '../../tests_results/views/test_results_v.dart';
import '../widgets/group_tile_w.dart';

class GroupTestDetailsView extends StatefulWidget {
  const GroupTestDetailsView({
    super.key,
    this.test,
    this.outerTest,
    this.bank,
  });
  final Test? test;
  final OuterTest? outerTest;
  final Bank? bank;
  @override
  State<GroupTestDetailsView> createState() => _GroupTestDetailsViewState();
}

class _GroupTestDetailsViewState extends State<GroupTestDetailsView> {
  @override
  void initState() {
    context.read<GroupTestDetailsCubit>().init(
          test: widget.test,
          bank: widget.bank,
          outerTest: widget.outerTest,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupTestDetailsCubit, GroupTestDetailsState>(
        builder: (context, state) {
          if (state is GroupTestDetailsPickGroup) {
            return PickGroupView(
              groups: state.groups,
              onPick: (index) {
                context.read<GroupTestDetailsCubit>().pickGroup(state.groups[index]);
              },
            );
          } else if (state is GroupTestDetailsInitial) {
            return GroupAndStudentResultDetailsView(state: state);
          } else if (state is GroupTestDetailsError) {
            return Scaffold(
              body: Center(
                child: Text(state.failure?.text ?? "حذث خطا ما"),
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

class GroupAndStudentResultDetailsView extends StatelessWidget {
  const GroupAndStudentResultDetailsView({super.key, required this.state});
  final GroupTestDetailsInitial state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          RepositoryDetailsItemWidget(
            averageMark: "%${state.details.averageMark * 100}",
            averageTime: ((state.details.averageTime)).toInt(),
            onTap: () {
              if (state.test != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TestAnswersPercentage(
                      details: state.details,
                      test: state.test!,
                    ),
                  ),
                );
              } else if (state.bank != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BankAnswersPercentage(
                      details: state.details,
                      bank: state.bank!,
                    ),
                  ),
                );
              } else if (state.outerTest != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OuterTestAnswersPercentage(
                      details: state.details,
                      test: state.outerTest!,
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: SizesResources.s2),
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
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                //
                return MarkInfoItemWidget(
                  //
                  name: state.results[index].$2.name,
                  //
                  markLetter: state.results[index].$1 == null
                      ? ""
                      : markToLatterFunction(
                          state.results[index].$1!.mark,
                        ),

                  mark: state.results[index].$1?.mark != null ? "%${state.results[index].$1?.mark}" : "لم يتم تقديم الاختبار",
                  //

                  time: state.results[index].$1 == null
                      ? ""
                      : periodToTextFunction(
                          state.details.marks[index].$1.period,
                        ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentView(
                          userName: state.results[index].$2.name,
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
    );
  }
}

class PickGroupView extends StatelessWidget {
  const PickGroupView({super.key, required this.groups, required this.onPick});
  final void Function(int index) onPick;
  final List<Group> groups;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختر مجموعة للمتابعة"),
      ),
      body: groups.isEmpty
          ? const Center(
              child: Text("لا يوجد عناصر لعرضها"),
            )
          : ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return GroupTileWidget(
                  group: groups[index],
                  onTap: () {
                    onPick(index);
                  },
                );
              },
            ),
    );
  }
}
