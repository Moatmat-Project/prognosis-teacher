import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

addToGroupDialog({
  required BuildContext context,
  required UserData userData,
  required Function(GroupItem item) onAdd,
}) {
  showDialog(
    context: context,
    builder: (context) => const Dialog(
      child: Column(
        children: [],
      ),
    ),
  );
}
