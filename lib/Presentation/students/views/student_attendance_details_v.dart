import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Presentation/students/state/blocs/explore_student_attendance_bloc.dart';
import 'package:moatmat_teacher/Presentation/students/widgets/student_attendance_tile_widget.dart';
import '../../../Core/functions/excel/export_student_attendance_excel.dart';
import '../../../Core/functions/pdf/export_student_attendance_pdf.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';

class StudentAttendanceDetailsView extends StatefulWidget {
  const StudentAttendanceDetailsView({super.key, required this.userData});
  final UserData userData;

  @override
  State<StudentAttendanceDetailsView> createState() => _StudentAttendanceDetailsViewState();
}

class _StudentAttendanceDetailsViewState extends State<StudentAttendanceDetailsView> {
  @override
  void initState() {
    locator<ExploreStudentAttendanceBloc>().add(LoadStudentAttendanceEvent(id: widget.userData.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider.value(
        value: locator<ExploreStudentAttendanceBloc>(),
        child: BlocConsumer<ExploreStudentAttendanceBloc, ExploreStudentAttendanceState>(
          listener: (context, state) {
            if (state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              return Column(
                children: [
                  TouchableTileWidget(
                    title: "تصدير بصيغة ملف اكسل",
                    onTap: () async {
                      await exportStudentAttendanceExcel(
                        userData: widget.userData,
                        sets: state.sets,
                        records: state.records,
                      );
                    },
                  ),
                  TouchableTileWidget(
                    title: "تصدير بصيغة ملف pdf",
                    onTap: () async {
                      await exportStudentAttendancePdf(
                        userData: widget.userData,
                        sets: state.sets,
                        records: state.records,
                      );
                    },
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60,
                        width: SpacingResources.mainHalfWidth(context),
                        padding: const EdgeInsets.symmetric(
                          vertical: SizesResources.s1,
                          horizontal: SizesResources.s5,
                        ).copyWith(top: SizesResources.s2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: ShadowsResources.mainBoxShadow,
                          color: ColorsResources.onPrimary,
                          border: Border.all(
                            width: 0.5,
                            color: ColorsResources.green,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "حضور",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                state.attendedCount.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: ColorsResources.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: SizesResources.s2),
                      Container(
                        height: 60,
                        width: SpacingResources.mainHalfWidth(context),
                        padding: const EdgeInsets.symmetric(
                          vertical: SizesResources.s1,
                          horizontal: SizesResources.s5,
                        ).copyWith(top: SizesResources.s2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: ShadowsResources.mainBoxShadow,
                          color: ColorsResources.onPrimary,
                          border: Border.all(
                            width: 0.5,
                            color: ColorsResources.red,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "غياب",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                state.notAttendedCount.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: ColorsResources.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.sets.length,
                      itemBuilder: (context, index) {
                        return AttendanceSetTileWidget(
                          set: state.sets[index],
                          record: state.records.where((e) => e.attendanceSetId == state.sets[index].id.toString()).firstOrNull,
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
    );
  }
}
