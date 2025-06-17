import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Presentation/groups/state/groups/students_groups_cubit.dart';
import 'package:moatmat_teacher/Presentation/statistics/views/export_students_statistics_view.dart';
import 'package:moatmat_teacher/Presentation/students/state/my_students/my_students_cubit.dart';
import 'package:moatmat_teacher/Presentation/students/views/my_students_v.dart';

class PickStudents extends StatefulWidget {
  const PickStudents({super.key, required this.group});
  final Group group;

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
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (context.read<MyStudentsCubit>().getSelectedUsers.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("اختر طالباً على الأقل")),
                          );
                          return;
                        }
                        List<UserData> filteredUsers = context.read<MyStudentsCubit>().getSelectedUsers.where((user) {
                          return !widget.group.items.any(
                            (existingUser) => existingUser.userData.id == user.id,
                          );
                        }).toList();
                        final int addedCnt = filteredUsers.length;
                        context.read<StudentsGroupsCubit>().addGroupItem(
                              groupId: widget.group.id,
                              userDataList: filteredUsers,
                            );
                        if (addedCnt > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("تمت إضافة $addedCnt طالب/ة إلى المجموعة")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("الطالب مضاف مسبقاً")),
                          );
                        }
                        Navigator.of(context).pop(filteredUsers);
                      },
                      child: Text("اضافة ${context.read<MyStudentsCubit>().getSelectedUsers.length} طالب"),
                    ),
                  ),
                ),
              ],
            ),
            appBar: AppBar(
              title: const Text("تحديد طلاب"),
              actions: [
                // Text(' عدد الطلاب : ${context.read<MyStudentsCubit>().getSelectedUsers.length}  '),
                // TextButton(
                //   onPressed: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (c) => ExportStudentsStatisticsView(
                //           students: state.users,
                //         ),
                //       ),
                //     );
                //   },
                //   child: Text("الإحصائيات"),
                // ),
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
                          forSelection: true,
                          onTap: () {
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
              title: const Text("تحديد طلاب"),
            ),
            body: Center(
              child: Text(state.error),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("تحديد طلاب"),
          ),
          body: const Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }
}
