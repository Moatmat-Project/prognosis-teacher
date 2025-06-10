import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/dialogs/add_set_d.dart';
import '../../../Core/functions/show_alert.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Features/attendance/domain/entities/attendance_set.dart';
import '../state/explore_attendance/explore_attendance_bloc.dart';

class AttendanceSetTileWidget extends StatelessWidget {
  const AttendanceSetTileWidget({
    super.key,
    required this.set,
    required this.onTap,
    required this.onDelete,
    required this.onUpdate,
  });
  final void Function(AttendanceSet set) onTap;
  final void Function(AttendanceSet set) onDelete;
  final void Function(AttendanceSet set) onUpdate;
  final AttendanceSet set;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
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
          onTap: () {
            onTap(set);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Row(children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    set.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(set.date),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              IconButton.filled(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue.withAlpha(14),
                ),
                icon: Icon(
                  Icons.edit,
                  size: 16,
                ),
                onPressed: () {
                  addSetDialog(
                    context: context,
                    initialTitle: set.title,
                    onSubmit: (title) {
                      onUpdate(
                        AttendanceSet(
                          id: set.id,
                          title: title,
                          teacher: set.teacher,
                          date: set.date,
                        ),
                      );
                    },
                  );
                },
                color: Colors.blue,
              ),
              IconButton.filled(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.withAlpha(14),
                ),
                icon: Icon(
                  Icons.delete,
                  size: 16,
                ),
                onPressed: () {
                  showAlert(
                    context: context,
                    title: "تأكيد الحذف",
                    body: "هل أنت متأكد من حذف هذه الجلسة؟",
                    agreeBtn: "حذف",
                    disagreeBtn: "إلغاء",
                    onAgree: () {
                      onDelete(set);
                    },
                  );
                },
                color: Colors.red,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
