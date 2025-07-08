import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/dialogs/add_to_group_d.dart';
import 'package:moatmat_teacher/Core/services/classification_s.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Presentation/export/views/results/choose_export_v.dart';
import 'package:moatmat_teacher/Presentation/groups/state/groups/students_groups_cubit.dart';
import 'package:moatmat_teacher/Presentation/notifications/views/send_notification_to_user_view.dart';
import 'package:moatmat_teacher/Presentation/students/state/my_students/my_students_cubit.dart';
import 'package:moatmat_teacher/Presentation/students/state/student/student_cubit.dart';
import 'package:moatmat_teacher/Presentation/students/views/student_reports_view.dart';
import 'package:moatmat_teacher/Presentation/students/views/student_result_details_v.dart';
import '../../../Core/functions/dialogs/add_to_class_d.dart';
import '../../../Core/functions/show_alert.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../widgets/result_tile_w.dart';
import 'student_attendance_details_v.dart';

class StudentView extends StatefulWidget {
  const StudentView({
    super.key,
    required this.userName,
    required this.userId,
    this.result,
  });
  final String userName;
  final String userId;
  final Result? result;
  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  @override
  void initState() {
    context.read<StudentCubit>().init(id: widget.userId, result: widget.result);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          if (state is StudentInitial) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  state.userData.name,
                  style: const TextStyle(fontSize: 12),
                ),
                actions: [
                  //
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChooseExportV(
                            results: state.results,
                            name: "result_of_student_${widget.userName}",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_open_sharp),
                  ),

                  //
                  const SizedBox(width: SizesResources.s2),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SendNotificationToUserView(
                            userData: state.userData,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notification_add),
                  ),
                  //
                  const SizedBox(width: SizesResources.s2),
                  //
                  IconButton(
                    onPressed: () async {
                      showAlert(
                        context: context,
                        title: "تاكيد الحذف",
                        body: "هل انت متاكد من انك تريد حذف جميع نتائج الطالب التي تخص اختباراتك؟",
                        onAgree: () async {
                          //
                          List<int> results = [];
                          //
                          results = state.results.map((e) => e.id).toList();
                          //
                          await context.read<StudentCubit>().deleteResult(results);
                          //
                          context.read<MyStudentsCubit>().init();
                          //
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<StudentCubit>().init(id: widget.userId);
                  return;
                },
                child: Column(
                  children: [
                    const SizedBox(height: SizesResources.s2),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 5),
                      child: Row(
                        children: [
                          Text("رقم الطالب : ${state.userData.id}"),
                        ],
                      ),
                    ),
                    const SizedBox(height: SizesResources.s2),
                    TouchableTileWidget(
                      title: "تقارير الطالب",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StudentReportsView(
                              results: state.results,
                            ),
                          ),
                        );
                      },
                    ),
                    TouchableTileWidget(
                      title: "حضور الطالب",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StudentAttendanceDetailsView(
                              userData: state.userData,
                            ),
                          ),
                        );
                      },
                    ),
                    TouchableTileWidget(
                      title: "تصنيف صف الطالب",
                      subTitle2: ClassificationService().getById(state.userData.uuid)?.classs,
                      onTap: () {
                        showAddToClass(
                          context: context,
                          uuid: state.userData.uuid,
                          onSave: () {
                            setState(() {});
                          },
                        );
                      },
                    ),
                    TouchableTileWidget(
                      title: "الإضافة إلى مجموعة",
                      onTap: () async {
                        int cnt = await addStudentToGroupDialog(
                          context: context,
                          groups: context.read<StudentsGroupsCubit>().groups,
                          onAdd: (groupId, filteredUsers) {
                            context.read<StudentsGroupsCubit>().addGroupItem(
                              groupId: groupId,
                              userDataList: filteredUsers,
                            );
                          },
                          userDataList: [state.userData],
                        );
                        if (cnt > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("تمت إضافة ${state.userData.name} طالب/ة إلى المجموعة")),
                          );
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("الطالب مضاف مسبقاً")),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: SizesResources.s2),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          return ResultTileWidget(
                            //
                            result: state.results[index],
                            //
                            onExploreResult: () {
                              context.read<StudentCubit>().showResultDetails(state.results[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is StudentResultDetails) {
            return StudentResultDetailsView(
              test: state.test,
              bank: state.bank,
              outerTest: state.outerTest,
              testAverage: state.testAverage,
              wrongAnswers: state.wrongAnswers,
              result: state.result,
              userData: state.userData,
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
