import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/dialogs/add_to_group_d.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Presentation/groups/state/groups/students_groups_cubit.dart';
import 'package:moatmat_teacher/Presentation/statistics/views/export_students_statistics_view.dart';
import 'package:moatmat_teacher/Presentation/students/state/my_students/my_students_cubit.dart';
import 'package:moatmat_teacher/Presentation/students/views/my_students_v.dart';

class PickStudents extends StatefulWidget {
  const PickStudents({super.key});

  @override
  State<PickStudents> createState() => _PickStudentsState();
}

class _PickStudentsState extends State<PickStudents> {
  late final TextEditingController _controller;

  @override
  void initState() {
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      context.read<MyStudentsCubit>().search(_controller.text);
      setState(() {});
    });
    //
    context.read<MyStudentsCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyStudentsCubit, MyStudentsState>(
      listener: (context, state) {
        //
      },
      builder: (context, state) {
        if (state is MyStudentsInitial) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final addedCnt = await addStudentToGroupDialog(
                  context: context,
                  groups: context.read<StudentsGroupsCubit>().groups,
                  userDataList: state.selectedUsers,
                  onAdd: (groupId, filteredUsers) {
                    context.read<StudentsGroupsCubit>().addGroupItem(
                          groupId: groupId,
                          userDataList: filteredUsers,
                        );
                  },
                );
                if (addedCnt > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("تمت إضافة $addedCnt طالب/ة إلى المجموعة")),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("الطالب مضاف مسبقاً")),
                  );
                }
              },
              child: Icon(Icons.person_add_alt_1),
            ),
            appBar: AppBar(
              title: const Text("طلابي"),
              actions: [
                Text(' عدد الطلاب : ${state.selectedUsers.length}  '),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => ExportStudentsStatisticsView(
                          students: state.users,
                        ),
                      ),
                    );
                  },
                  child: Text("الإحصائيات"),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<MyStudentsCubit>().update();
              },
              child: Column(
                children: [
                  const SizedBox(height: SizesResources.s2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: SpacingResources.mainWidth(context),
                        child: Text(
                          "العدد الكلي : ${state.users.length}",
                          style: const TextStyle(
                            color: ColorsResources.blackText2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizesResources.s2),
                  MyTextFormFieldWidget(
                    hintText: "بحث",
                    suffix: const Icon(Icons.search),
                    controller: _controller,
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        //
                        final item = state.users[index];
                        final selected = context.read<MyStudentsCubit>().isSelected(item);
                        //

                        return StudentTileWidget(
                          userData: state.users[index],
                          isSelected: selected,
                          forSelecion: true,
                          onTap: (){
                            context.read<MyStudentsCubit>().toggleSelection(item);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is MyStudentsError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("طلابي"),
            ),
            body: Center(
              child: Text(state.error),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("طلابي"),
          ),
          body: const Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }
}
