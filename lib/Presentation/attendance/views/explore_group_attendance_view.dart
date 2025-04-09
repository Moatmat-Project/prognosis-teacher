import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Presentation/attendance/state/explore_group_attendance/explore_group_attendance_bloc.dart';
import 'package:moatmat_teacher/Presentation/groups/views/group_test_details_v.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';

class ExploreGroupAttendanceView extends StatefulWidget {
  const ExploreGroupAttendanceView({super.key, required this.set, required this.records});
  final AttendanceSet set;
  final List<AttendanceRecord> records;
  @override
  State<ExploreGroupAttendanceView> createState() => _ExploreGroupAttendanceViewState();
}

class _ExploreGroupAttendanceViewState extends State<ExploreGroupAttendanceView> {
  @override
  void initState() {
    locator<ExploreGroupAttendanceBloc>().add(InitializeAttendanceEvent(
      widget.set,
      widget.records,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: locator<ExploreGroupAttendanceBloc>(),
        child: BlocBuilder<ExploreGroupAttendanceBloc, ExploreGroupAttendanceState>(
          builder: (context, state) {
            if (state is ExploreGroupAttendancePickGroup) {
              return PickGroupView(
                groups: state.groups,
                onPick: (index) {
                  context.read<ExploreGroupAttendanceBloc>().add(
                        PickGroupEvent(
                          state.groups[index],
                        ),
                      );
                },
              );
            } else if (state is ExploreGroupAttendanceDetails) {
              return ExploreGroupAttendanceDetailsView(state: state);
            }
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ExploreGroupAttendanceDetailsView extends StatelessWidget {
  const ExploreGroupAttendanceDetailsView({super.key, required this.state});
  final ExploreGroupAttendanceDetails state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.group.name),
        leading: IconButton(
          onPressed: () {
            locator<ExploreGroupAttendanceBloc>().add(InitializeAttendanceEvent(
              state.set,
              state.records,
            ));
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: SizesResources.s2),
          Container(
            width: SpacingResources.mainWidth(context),
            padding: const EdgeInsets.symmetric(
              vertical: SizesResources.s2,
              horizontal: SizesResources.s4,
            ).copyWith(top: SizesResources.s2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: ShadowsResources.mainBoxShadow,
              color: ColorsResources.onPrimary,
            ),
            child: Column(
              children: [
                const SizedBox(height: SizesResources.s3),
                Row(
                  children: [
                    Text(
                      state.set.title,
                      style: TextStyle(
                        fontSize: 19,
                        color: ColorsResources.blackText1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(state.set.date),
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsResources.blackText2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('yyyy/MM/dd').format(state.set.date),
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsResources.blackText2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SizesResources.s2),
              ],
            ),
          ),
          const SizedBox(height: SizesResources.s2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: SpacingResources.mainHalfWidth(context),
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s1,
                  horizontal: SizesResources.s3,
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
                      "عدد الحضور",
                      style: TextStyle(
                        fontSize: 11,
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
                height: 50,
                width: SpacingResources.mainHalfWidth(context),
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s1,
                  horizontal: SizesResources.s3,
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
                      "عدد الغياب",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        state.absentCount.toString(),
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
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 2,
                crossAxisSpacing: SizesResources.s2,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: SizesResources.s2,
              ),
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                return AttendanceInfoItemWidget(
                  student: state.students[index],
                  record: state.records.where((e) => e.studentId == state.students[index].id).firstOrNull,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceInfoItemWidget extends StatelessWidget {
  const AttendanceInfoItemWidget({super.key, required this.record, required this.student});
  final UserData student;
  final AttendanceRecord? record;

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
        border: record == null
            ? Border.all(
                color: ColorsResources.red,
              )
            : null,
      ),
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
                      student.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: SizesResources.s1),
                  if (record != null)
                    Text(
                      DateFormat('hh:mm a').format(record!.date),
                      style: const TextStyle(
                        color: ColorsResources.blackText2,
                        fontSize: 12,
                      ),
                    )
                  else
                    Text(
                      "غائب",
                      style: const TextStyle(
                        color: ColorsResources.blackText2,
                        fontSize: 12,
                      ),
                    ),
                  if (record != null)
                    Text(
                      DateFormat('yyyy/MM/dd').format(record!.date),
                      style: const TextStyle(
                        color: ColorsResources.blackText2,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: SizesResources.s2),
          ],
        ),
      ),
    );
  }
}
