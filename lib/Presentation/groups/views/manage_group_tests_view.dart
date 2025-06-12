import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_tests_v.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/tests/domain/entities/test/test.dart';
import '../state/manage_group_tests/manage_group_tests_bloc.dart';

class ManageGroupTestsView extends StatefulWidget {
  const ManageGroupTestsView({
    super.key,
    required this.group,
    required this.isCourseSubscribersGroup,
  });
  final Group group;
  final bool isCourseSubscribersGroup;
  @override
  State<ManageGroupTestsView> createState() => _ManageGroupTestsViewState();
}

class _ManageGroupTestsViewState extends State<ManageGroupTestsView> {
  @override
  void initState() {
    locator<ManageGroupTestsBloc>().add(ManageGroupTestsLoadEvent(
      group: widget.group,
      isCourseSubscribersGroup: widget.isCourseSubscribersGroup,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: locator<ManageGroupTestsBloc>(),
        child: BlocBuilder<ManageGroupTestsBloc, ManageGroupTestsState>(
          builder: (context, state) {
            print(state.selectedTests);
            if (state is ManageGroupTestsLoading) {
              return ManageGroupTestsLoadingView(state: state);
            }
            if (state is ManageGroupTestsInitial) {
              return ManageGroupTestsInitialView(state: state);
            }
            if (state is ManageGroupTestsPickTests) {
              return ManageGroupTestsPickTestsView(state: state);
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

class ManageGroupTestsLoadingView extends StatelessWidget {
  const ManageGroupTestsLoadingView({super.key, required this.state});
  final ManageGroupTestsLoading state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

class ManageGroupTestsInitialView extends StatefulWidget {
  const ManageGroupTestsInitialView({super.key, required this.state});
  final ManageGroupTestsInitial state;

  @override
  State<ManageGroupTestsInitialView> createState() => _ManageGroupTestsInitialViewState();
}

class _ManageGroupTestsInitialViewState extends State<ManageGroupTestsInitialView> {
  bool canPop = false;
  @override
  Widget build(BuildContext context) {
    print("debugging ${widget.state.selectedTests.map((e) => e.id).contains(2197)}");
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.state.canSaving) {
          showAlert(
            context: context,
            title: "حفظ التغييرات",
            body: "هل تريد مغادرة الصفحة دون حفظ التغييرات؟",
            agreeBtn: "تأكيد",
            onAgree: () {
              setState(() => canPop = true);
              Navigator.of(context).pop();
            },
          );
        } else {
          setState(() => canPop = true);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                locator<ManageGroupTestsBloc>().add(ManageGroupTestsStartPickTestEvent());
              },
              child: Text("تحديد اختبارات"),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchInTestsView(tests: widget.state.selectedTests, onPick: (t) {}),
                  ),
                );
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        bottomNavigationBar: widget.state.canSaving
            ? SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButtonWidget(
                      text: "حفظ",
                      loading: widget.state.isLoading,
                      onPressed: () {
                        locator<ManageGroupTestsBloc>().add(ManageGroupTestsSaveChangesEvent());
                      },
                    )
                  ],
                ),
              )
            : null,
        body: widget.state.selectedTests.isEmpty
            ? Center(
                child: Text("لا يوجد اختبارات محددة"),
              )
            : ListView.builder(
                itemCount: widget.state.selectedTests.length,
                itemBuilder: (context, index) {
                  return _TestTileWidget(
                    dismissible: true,
                    test: widget.state.selectedTests[index],
                    selected: widget.state.selectedTests.contains(widget.state.selectedTests[index]),
                    onSelect: () {
                      locator<ManageGroupTestsBloc>().add(ManageGroupTestsAddTestEvent(widget.state.selectedTests[index]));
                    },
                    onUnSelect: () {
                      locator<ManageGroupTestsBloc>().add(ManageGroupTestsRemoveTestEvent(widget.state.selectedTests[index]));
                    },
                  );
                },
              ),
      ),
    );
  }
}

class ManageGroupTestsPickTestsView extends StatefulWidget {
  const ManageGroupTestsPickTestsView({super.key, required this.state});
  final ManageGroupTestsPickTests state;

  @override
  State<ManageGroupTestsPickTestsView> createState() => _ManageGroupTestsPickTestsViewState();
}

class _ManageGroupTestsPickTestsViewState extends State<ManageGroupTestsPickTestsView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        locator<ManageGroupTestsBloc>().add(ManageGroupTestsPopBackEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              locator<ManageGroupTestsBloc>().add(ManageGroupTestsPopBackEvent());
            },
            icon: Icon(widget.state.canPop ? Icons.arrow_back : Icons.close),
          ),
        ),
        body: widget.state.isLoading
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : ListView.builder(
                itemCount: getItemLength(widget.state),
                itemBuilder: (context, index) {
                  return getWidgetByIndex(widget.state, context, index);
                },
              ),
      ),
    );
  }

  int getItemLength(ManageGroupTestsPickTests state) {
    int length = 0;
    length += state.folders.length;
    length += state.tests.length;
    return length;
  }

  Widget getWidgetByIndex(ManageGroupTestsPickTests state, BuildContext context, int index) {
    //
    int fLength = state.folders.length;
    //
    if (index < fLength) {
      return InkWell(
        child: _FolderItemWidget(
          folder: state.folders[index],
          onTap: () {
            locator<ManageGroupTestsBloc>().add(ManageGroupTestsOpenFolderEvent(state.folders[index]));
          },
        ),
      );
    } else {
      return InkWell(
        child: _TestTileWidget(
          test: state.tests[index - fLength],
          selected: widget.state.selectedTests.contains(state.tests[index - fLength].id),
          onSelect: () {
            locator<ManageGroupTestsBloc>().add(ManageGroupTestsAddTestEvent(state.tests[index - fLength]));
          },
          onUnSelect: () {
            locator<ManageGroupTestsBloc>().add(ManageGroupTestsRemoveTestEvent(state.tests[index - fLength]));
          },
        ),
      );
      //
    }
  }
}

class _FolderItemWidget extends StatelessWidget {
  const _FolderItemWidget({
    super.key,
    required this.folder,
    this.onTap,
  });
  final String folder;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          width: SpacingResources.mainWidth(context),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: ColorsResources.borders,
              ),
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s4,
                  horizontal: SizesResources.s2,
                ),
                child: Row(
                  children: [
                    //
                    const Icon(
                      Icons.folder,
                      size: 30,
                      color: ColorsResources.primary,
                    ),
                    //
                    const SizedBox(width: SizesResources.s2),
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        folder,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //
                    const Spacer(),
                    //
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _TestTileWidget extends StatefulWidget {
  const _TestTileWidget({
    super.key,
    required this.test,
    required this.onSelect,
    required this.onUnSelect,
    required this.selected,
    this.dismissible = false,
  });
  final bool selected, dismissible;
  final Test test;
  final VoidCallback onSelect, onUnSelect;

  @override
  State<_TestTileWidget> createState() => _TestTileWidgetState();
}

class _TestTileWidgetState extends State<_TestTileWidget> {
  late bool _isSelected;
  @override
  void initState() {
    _isSelected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: ColorsResources.background,
            border: const Border(
              bottom: BorderSide(color: ColorsResources.borders),
            ),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (widget.dismissible) return;
                if (_isSelected) {
                  widget.onUnSelect();
                } else {
                  widget.onSelect();
                }
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SizesResources.s3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.test.information.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ColorsResources.blackText1,
                          ),
                        ),
                        Text(
                          "${widget.test.questions.length.toString()} سؤال",
                          style: const TextStyle(
                            fontSize: 10,
                            color: ColorsResources.blackText2,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (widget.dismissible)
                      IconButton(
                        onPressed: () {
                          widget.onUnSelect();
                          setState(() {});
                        },
                        icon: Icon(Icons.close),
                      )
                    else
                      Checkbox(
                        value: _isSelected,
                        onChanged: (v) {
                          if (widget.dismissible) return;
                          if (_isSelected) {
                            widget.onUnSelect();
                          } else {
                            widget.onSelect();
                          }
                          setState(() {
                            _isSelected = !_isSelected;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
