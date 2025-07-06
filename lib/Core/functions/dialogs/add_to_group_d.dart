import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/drop_down_w.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

Future<int> addStudentToGroupDialog({
  required BuildContext context,
  required List<UserData> userDataList,
  required List<Group> groups,
  required Function(int groupId, List<UserData> filteredUsers) onAdd,
}) async {
  List<String> groupName = groups.map((e) => e.name).toList();
  String selectedGroup = groupName.first;
  return await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("إضافة الطلاب إلى"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: SpacingResources.mainHalfWidth(context) * 1.4,
            child: DropDownWidget(
              items: groupName,
              selectedItem: groupName.first,
              hintText: "المجموعة",
              onChanged: (p0) {
                selectedGroup = p0 ?? selectedGroup;
              },
              onSaved: (p0) {},
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final selected = groups.firstWhere((e) => e.name == selectedGroup);
            List<UserData> filteredUsers = userDataList.where((user) {
              return !selected.items.any((existingUser) => existingUser.userData.id == user.id);
            }).toList();

            onAdd(selected.id, filteredUsers);
            Navigator.of(context).pop(filteredUsers.length);
          },
          child: const Text("إضافة"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(0);
          },
          child: const Text("إلغاء"),
        ),
      ],
    ),
  ) ?? 0;
}
