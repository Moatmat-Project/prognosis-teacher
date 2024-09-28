import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/constant/classes_list.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/drop_down_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Presentation/groups/state/groups/students_groups_cubit.dart';
import 'package:moatmat_teacher/Presentation/groups/views/groups_v.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../widgets/group_tile_w.dart';

class AddToGroupView extends StatefulWidget {
  const AddToGroupView({
    super.key,
    required this.userData,
  });
  final UserData userData;

  @override
  State<AddToGroupView> createState() => _AddToGroupViewState();
}

class _AddToGroupViewState extends State<AddToGroupView> {
//
  onAdd({required int groupId}) async {
    //
    final cubit = context.read<StudentsGroupsCubit>();
    //
    await cubit.addGroupItem(
      userData: widget.userData,
      groupId: groupId,
    );
    //
    if (mounted) {
      //
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تمت الاضافة"),
        ),
      );
      //
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentsGroupsCubit>();
    return Scaffold(
        appBar: AppBar(
          title: Text("اضافة ${widget.userData.name} الى مجموعة"),
        ),
        body: ListView.builder(
          itemCount: cubit.groups.length,
          itemBuilder: (context, index) {
            return GroupTileWidget(
              group: cubit.groups[index],
              onLongPress: () {
                showAlert(
                  context: context,
                  title: "حذف مجموعة ${cubit.groups[index].name}",
                  body: "هل انت متاكد من رغبتك بحذف المجموعة؟",
                  agreeBtn: "حذف",
                  onAgree: () {
                    context.read<StudentsGroupsCubit>().deleteGroup(
                          groupId: cubit.groups[index].id,
                        );
                  },
                );
              },
              onTap: () {
                onAdd(groupId: cubit.groups[index].id);
              },
            );
          },
        ));
  }
}
