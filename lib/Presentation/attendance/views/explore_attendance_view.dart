import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Presentation/attendance/state/explore_attendance/explore_attendance_bloc.dart';
import 'package:moatmat_teacher/Presentation/attendance/views/set_up_attendance_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../Core/functions/dialogs/add_set_d.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../widgets/attendance_set_tile_widget.dart';

class ExploreAttendanceView extends StatefulWidget {
  const ExploreAttendanceView({super.key, this.isOffline = false});
  final bool isOffline;
  @override
  State<ExploreAttendanceView> createState() => _ExploreAttendanceViewState();
}

class _ExploreAttendanceViewState extends State<ExploreAttendanceView> {
  //
  late final TextEditingController _controller;
  List<AttendanceSet> sets = [];
  List<AttendanceSet> search = [];
  //
  @override
  void initState() {
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        search = sets;
      } else {
        search = sets.where((e) {
          return e.title.contains(_controller.text);
        }).toList();
      }
      setState(() {});
    });
    //
    locator<ExploreAttendanceBloc>().add(LoadAttendanceEvent(isOffline: widget.isOffline));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("جلسات الحضور"),
      ),
      body: BlocProvider.value(
        value: locator<ExploreAttendanceBloc>(),
        child: BlocBuilder<ExploreAttendanceBloc, ExploreAttendanceState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state.error != null) {
              return Center(
                child: Text(state.error!),
              );
            } else {
              sets = state.attendanceSets;
              if (_controller.text.isEmpty) {
                search = sets;
              }
              return Column(
                children: [
                  const SizedBox(height: SizesResources.s2),
                  MyTextFormFieldWidget(
                    hintText: "بحث",
                    suffix: const Icon(Icons.search),
                    controller: _controller,
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: search.length,
                      itemBuilder: (context, index) {
                        final set = search[index];
                        return AttendanceSetTileWidget(
                          set: set,
                          onDelete: (set) {
                            context.read<ExploreAttendanceBloc>().add(
                                  DeleteAttendanceEvent(
                                    set.id,
                                    isOffline: widget.isOffline,
                                  ),
                                );
                          },
                          onUpdate: (set) {
                            context.read<ExploreAttendanceBloc>().add(
                                  UpdateAttendanceEvent(
                                    set,
                                    isOffline: widget.isOffline,
                                  ),
                                );
                          },
                          onTap: (AttendanceSet set) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SetUpAttendanceView(
                                  set: set,
                                  isOffline: widget.isOffline,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsResources.primary,
        foregroundColor: ColorsResources.whiteText1,
        onPressed: () {
          addSetDialog(
            context: context,
            onSubmit: (title) {
              context.read<ExploreAttendanceBloc>().add(
                    CreateAttendanceEvent(
                      AttendanceSet(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: title,
                        teacher: Supabase.instance.client.auth.currentUser!.email ?? "",
                        date: DateTime.now(),
                      ),
                      isOffline: widget.isOffline,
                    ),
                  );
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
