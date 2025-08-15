import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_outer_tests_v.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_tests_v.dart';
import 'package:moatmat_teacher/Presentation/scanner/views/explore_outer_tests_v.dart';
import 'package:moatmat_teacher/Presentation/tests/state/my_tests/my_tests_cubit.dart';
import 'package:moatmat_teacher/Presentation/tests/views/add_outer_test_view.dart';
import 'package:moatmat_teacher/Presentation/tests/views/outer_test_details_v.dart';
import 'package:moatmat_teacher/Presentation/tests/views/test_details_v.dart';
import 'package:moatmat_teacher/Presentation/tests/views/tests_and_folders_builder_v.dart';

import '../../scanner/state/cubit/explore_outer_tests_cubit.dart';
import 'add_test_vew.dart';

class MyTestsView extends StatefulWidget {
  const MyTestsView({super.key});

  @override
  State<MyTestsView> createState() => _MyTestsViewState();
}

class _MyTestsViewState extends State<MyTestsView> {
  int selectedTab = 0;
  @override
  void initState() {
    context.read<MyTestsCubit>().init();
    print('hi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyTestsCubit, MyTestsState>(
        builder: (context, state) {
          if (state is MyTestsInitial) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    onTap: (value) {
                      setState(() {
                        selectedTab = value;
                      });
                    },
                    tabs: const [
                      Tab(text: 'الاختبارات'),
                      Tab(text: 'اختبارات خارجية'),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (selectedTab == 0) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchInTestsView(
                                tests: state.tests,
                                onPick: (test) async {
                                  await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => TestDetailsView(
                                        testId: test.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else if (selectedTab == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchInOuterTestsView(
                                onPick: (test) async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => OUterTestDetailsView(
                                        test: test,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                body: TabBarView(
                  children: [
                    // First tab content
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<MyTestsCubit>().update();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: SizesResources.s2),
                        child: TestsAndFoldersViewBuilder(
                          tests: state.tests,
                          folders: const [],
                          onOpenTest: (i, t) async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TestDetailsView(
                                  testId: state.tests[i].id,
                                ),
                              ),
                            );
                            if (mounted) {
                              context.read<MyTestsCubit>().update();
                            }
                          },
                          onOpenFolder: (i, f) async {},
                          onBack: () {},
                          onDeleteFolder: (int i, String f) {},
                          onUpdateFolder: (int i, String f) {},
                        ),
                      ),
                    ),
                    // Second tab content
                    const Padding(
                      padding: EdgeInsets.only(top: SizesResources.s2),
                      child: ExploreOuterTestsView(),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MyTestsError) {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  state.exception.toString(),
                  textAlign: TextAlign.center,
                )),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: BlocBuilder<MyTestsCubit, MyTestsState>(
        builder: (context, state) {
          return SpeedDial(
            animatedIcon: AnimatedIcons.menu_home,
            children: [
              SpeedDialChild(
                label: "إضافة أختبار",
                child: const Icon(Icons.add),
                onTap: () async {
                  await Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const AddTestView(),
                        ),
                      )
                      .then(
                        (value) => context.read<MyTestsCubit>().update(),
                      );
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              SpeedDialChild(
                label: "تصميم سلم اختبار خارجي",
                child: const Icon(Icons.add),
                onTap: () async {
                  await Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const AddOuterTestView(),
                        ),
                      )
                      .then(
                        (value) => context.read<ExploreOuterTestsCubit>().init(),
                      );
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
