import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/functions/dialogs/add_attendance_records_d.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_attendance_records_v.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Presentation/attendance/views/explore_group_attendance_view.dart';
import 'package:moatmat_teacher/Presentation/attendance/views/scanning_students_codes_view.dart';
import 'package:moatmat_teacher/Presentation/attendance/widgets/attendance_record_tile_widget.dart';
import 'package:moatmat_teacher/Presentation/students/views/pick_students_v.dart';
import '../state/set_up_attendance/set_up_attendance_bloc.dart';
import 'export_attendance_set_v.dart';

class SetUpAttendanceView extends StatefulWidget {
  const SetUpAttendanceView({super.key, required this.set, this.isOffline = false});
  final bool isOffline;
  final AttendanceSet set;
  @override
  State<SetUpAttendanceView> createState() => _SetUpAttendanceViewState();
}

class _SetUpAttendanceViewState extends State<SetUpAttendanceView> {
  late bool canPop;
  @override
  void initState() {
    locator<SetUpAttendanceBloc>().add(LoadRecordsEvent(widget.set, isOffline: widget.isOffline));
    canPop = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: locator<SetUpAttendanceBloc>(),
        child: BlocConsumer<SetUpAttendanceBloc, SetUpAttendanceState>(
          listener: (context, state) {
            if (state.message != null && !state.isLoading) {
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          builder: (context, state) {
            if (state.canSave == true && canPop == true) {
              canPop = false;
            }
            if (state.isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            late List<AttendanceRecord> records;
            if (state.ending != null && state.starting != null) {
              records = state.records.where((element) {
                return element.date.isAfter(state.starting!.add(Duration(minutes: -1))) && element.date.isBefore(state.ending!.add(Duration(minutes: 1)));
              }).toList();
            } else {
              records = state.records;
            }

            return PopScope(
              canPop: canPop,
              onPopInvokedWithResult: (didPop, result) {
                if (state.canSave && !didPop) {
                  showAlert(
                    context: context,
                    title: "تغييرات غير محفوظة",
                    body: "هل تريد الخروج دون حفظ التغييرات؟",
                    onAgree: () {
                      setState(() {
                        canPop = true;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  );
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0.0,
                  centerTitle: false,
                  title: Text(
                    widget.set.title,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchInAttendanceRecordsView(records: records),
                          ),
                        );
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
                bottomNavigationBar: state.canSave || state.isSaving
                    ? SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButtonWidget(
                              loading: state.isSaving,
                              onPressed: () {
                                locator<SetUpAttendanceBloc>().add(
                                  SaveChangesEvent(isOffline: widget.isOffline),
                                );
                              },
                              text: ("حفظ التغييرات"),
                            ),
                          ],
                        ),
                      )
                    : null,
                body: Column(
                  children: [
                    SizedBox(
                      width: SpacingResources.mainWidth(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _BoxedButton(
                            icon: Icons.qr_code,
                            text: "بدء المسح",
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScanningStudentsCodesView(
                                    setId: widget.set.id.toString(),
                                    onReadRecord: (record) {
                                      locator<SetUpAttendanceBloc>().add(
                                        AddRecordEvent(record),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          _BoxedButton(
                              icon: Icons.keyboard,
                              text: "ادخال يدوي",
                              onTap: () {
                                addAttendanceRecordsFunction(
                                  context: context,
                                  onAdd: (studentId) {
                                    locator<SetUpAttendanceBloc>().add(
                                      AddRecordEvent(
                                        AttendanceRecord(
                                          id: DateTime.now().millisecondsSinceEpoch,
                                          attendanceSetId: widget.set.id.toString(),
                                          studentName: "",
                                          studentId: studentId,
                                          date: DateTime.now(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                          _BoxedButton(
                            icon: Icons.person,
                            text: "أختيار طالب",
                            enabled: !widget.isOffline,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PickStudentsView(
                                    onPick: (user) {
                                      locator<SetUpAttendanceBloc>().add(
                                        AddRecordEvent(
                                          AttendanceRecord.fromUserData(
                                            attendanceSetId: widget.set.id.toString(),
                                            user: user,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    if (!widget.isOffline) ...[
                      TouchableTileWidget(
                        icon: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "  ${records.length}  ",
                                        style: TextStyle(
                                          color: ColorsResources.blackText1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.person,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: "تصدير الحضور ",
                        onTap: records.isEmpty
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ExportAttendanceSetView(
                                      set: widget.set,
                                      records: records,
                                    ),
                                  ),
                                );
                              },
                      ),
                      TouchableTileWidget(
                        title: "مجموعات الطلاب",
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                        ),
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ExploreGroupAttendanceView(
                                set: widget.set,
                                records: records,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    if (state.records.isNotEmpty && state.starting != null && state.starting != null)
                      TimeRangeWidget(
                        studentsCount: state.records.length,
                        starting: state.starting!,
                        ending: state.ending!,
                        onChangeEndingDate: (date) {
                          locator<SetUpAttendanceBloc>().add(
                            ChangeRangeFiltersEvent(ending: date),
                          );
                        },
                        onChangeStartingDate: (date) {
                          locator<SetUpAttendanceBloc>().add(
                            ChangeRangeFiltersEvent(starting: date),
                          );
                        },
                      ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];

                          return AttendanceRecordTileWidget(
                            record: record,
                            onRemove: () {
                              locator<SetUpAttendanceBloc>().add(
                                DeleteRecordEvent(record),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TimeRangeWidget extends StatelessWidget {
  const TimeRangeWidget({
    super.key,
    required this.studentsCount,
    required this.starting,
    required this.ending,
    required this.onChangeStartingDate,
    required this.onChangeEndingDate,
  });
  final int studentsCount;
  final DateTime starting, ending;
  final void Function(DateTime date) onChangeStartingDate;
  final void Function(DateTime date) onChangeEndingDate;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: SpacingResources.mainWidth(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsResources.primary.withAlpha(50),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: ColorsResources.darkPrimary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(starting),
                                    );
                                    if (picked != null) {
                                      onChangeStartingDate(adjustDate(starting, newTime: picked));
                                    }
                                  },
                                  child: Text(
                                    DateFormat('hh:mm a').format(starting),
                                    style: TextStyle(
                                      color: ColorsResources.primary,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Tajawal",
                                      fontSize: 19,
                                      decorationColor: ColorsResources.primary.withAlpha(200),
                                      decorationThickness: 15,
                                      decorationStyle: TextDecorationStyle.solid,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    firstDate: starting,
                                    lastDate: ending,
                                    initialDate: starting,
                                    keyboardType: TextInputType.text,
                                  );
                                  if (picked != null) {
                                    onChangeStartingDate(adjustDate(starting, newDate: picked));
                                  }
                                },
                                child: Text(
                                  DateFormat('MM/dd').format(starting),
                                  style: TextStyle(
                                    color: ColorsResources.primary.withAlpha(200),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Tajawal",
                                    fontSize: 16,
                                    decorationColor: ColorsResources.primary.withAlpha(200),
                                    decorationThickness: 15,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 10, right: 10),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: ColorsResources.primary,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsResources.primary.withAlpha(50),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: ColorsResources.darkPrimary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(ending),
                                    );
                                    onChangeEndingDate(adjustDate(ending, newTime: picked));
                                  },
                                  child: Text(
                                    DateFormat('hh:mm a').format(ending),
                                    style: TextStyle(
                                      color: ColorsResources.primary,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Tajawal",
                                      fontSize: 19,
                                      decorationColor: ColorsResources.primary,
                                      decorationThickness: 15,
                                      decorationStyle: TextDecorationStyle.solid,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    firstDate: starting,
                                    lastDate: ending,
                                    initialDate: ending,
                                    keyboardType: TextInputType.text,
                                  );
                                  onChangeEndingDate(adjustDate(ending, newDate: picked));
                                },
                                child: Text(
                                  DateFormat('MM/dd').format(ending),
                                  style: TextStyle(
                                    color: ColorsResources.primary.withAlpha(200),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Tajawal",
                                    fontSize: 16,
                                    decorationThickness: 15,
                                    decorationColor: ColorsResources.primary,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  DateTime adjustDate(DateTime date, {TimeOfDay? newTime, DateTime? newDate}) {
    if (newTime != null) {
      return DateTime(date.year, date.month, date.day, newTime.hour, newTime.minute);
    }
    if (newDate != null) {
      return DateTime(newDate.year, newDate.month, newDate.day, date.hour, date.minute);
    }
    return DateTime.now();
  }
}

class _BoxedButton extends StatelessWidget {
  const _BoxedButton({required this.icon, required this.text, required this.onTap, this.enabled = true});
  final bool enabled;
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainWidth(context) / 3.1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: enabled ? null : Colors.black38),
                SizedBox(height: SizesResources.s2),
                Text(
                  text,
                  style: TextStyle(color: enabled ? null : Colors.black38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
