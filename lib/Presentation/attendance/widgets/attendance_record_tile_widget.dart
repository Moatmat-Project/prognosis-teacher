import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Core/functions/show_alert.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/attendance/domain/entities/attendance_record.dart';

class AttendanceRecordTileWidget extends StatelessWidget {
  const AttendanceRecordTileWidget({
    super.key,
    required this.record,
    this.onRemove,
  });
  final VoidCallback? onRemove;
  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الاسم : ${record.studentName}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorsResources.blackText1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "المعرف : ${record.studentId.padLeft(6, "0")}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorsResources.blackText2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          DateFormat('MM/dd - hh:mm a').format(record.date),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorsResources.blackText2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (onRemove != null)
                  InkWell(
                    onTap: () {
                      showAlert(
                        context: context,
                        title: "ازالة الحضور",
                        body: "هل تريد حذف هذا الحضور ؟",
                        onAgree: onRemove!,
                      );
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black45,
                      size: 17,
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
