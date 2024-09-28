import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/outer_tests_results/views/test_results_v.dart';
import 'package:moatmat_teacher/Presentation/tests/state/outer_test_information/outer_test_information_cubit.dart';

import '../../groups/views/group_test_details_v.dart';
import '../../scanner/state/cubit/explore_outer_tests_cubit.dart';
import '../../tests_results/views/test_results_v.dart';
import 'add_outer_test_view.dart';

class OUterTestDetailsView extends StatefulWidget {
  const OUterTestDetailsView({
    super.key,
    this.test,
    this.testId,
  });
  final int? testId;
  final OuterTest? test;
  @override
  State<OUterTestDetailsView> createState() => _OUterTestDetailsViewState();
}

class _OUterTestDetailsViewState extends State<OUterTestDetailsView> {
  late Test test;
  @override
  void initState() {
    context.read<OuterTestInformationCubit>().init(
          test: widget.test,
          testId: widget.testId,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OuterTestInformationCubit, OuterTestInformationState>(
        builder: (context, state) {
          if (state is OuterTestInformationInitial) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.test.information.title),
              ),
              body: Column(
                children: [
                  TouchableTileWidget(
                    title: "تعديل الاختبار",
                    iconData: Icons.edit,
                    onTap: () async {
                      if (locator<TeacherData>().options.allowUpdate) {
                        //
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddOuterTestView(
                            test: state.test,
                          ),
                        ));
                        //
                        if (mounted) {
                          context.read<ExploreOuterTestsCubit>().init();
                          Navigator.of(context).pop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  TouchableTileWidget(
                    title: "تفاصيل مجموعات الطلاب",
                    iconData: Icons.people,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GroupTestDetailsView(
                            outerTest: state.test,
                          ),
                        ),
                      );
                    },
                  ),
                  TouchableTileWidget(
                    title: "حذف الاختبار",
                    iconData: Icons.delete,
                    onTap: () {
                      if (locator<TeacherData>().options.allowDelete) {
                        showAlert(
                          context: context,
                          title: "تأكيد",
                          body: "هل انت متاكد من انك تريد حذف الأختبار",
                          onAgree: () {
                            context.read<ExploreOuterTestsCubit>().deleteTest(state.test.id);
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: SpacingResources.mainWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TouchableTileWidget(
                          title: "تصفح نتائج الأختبار",
                          iconData: Icons.arrow_forward_ios,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OuterTestResultsView(
                                  test: state.test,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is OuterTestInformationError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text(state.message ?? ""),
              ),
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
