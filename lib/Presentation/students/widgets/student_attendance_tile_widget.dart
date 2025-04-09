import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Features/attendance/domain/entities/attendance_set.dart';

class AttendanceSetTileWidget extends StatelessWidget {
  const AttendanceSetTileWidget({
    super.key,
    required this.set,
    required this.record,
  });
  final AttendanceSet set;
  final AttendanceRecord? record;

  @override
  Widget build(BuildContext context) {
    bool attended = record != null;
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: Row(children: [
            Expanded(
              child: ListTile(
                title: Text(
                  "اسم الجلسة : ${set.title}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('تاريخ الجلسة : dd/MM/yyyy').format(set.date),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (record != null)
                      Text(
                        DateFormat('تاريخ الحضور : dd/MM/yyyy').format(record!.date),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
                isThreeLine: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: attended ? Colors.green.withAlpha(40) : Colors.red.withAlpha(40),
                child: Icon(
                  attended ? Icons.check : Icons.close,
                  color: attended ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
