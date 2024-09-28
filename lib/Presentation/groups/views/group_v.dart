import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/constant/classes_list.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';
import 'package:moatmat_teacher/Presentation/notifications/views/send_bulk_notification_v.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../students/views/my_students_v.dart';
import '../state/groups/students_groups_cubit.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key, required this.group});
  final Group group;

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
//
  String? classRoom;
//
  late final TextEditingController _controller;
//
  late Group group;
//
  List<GroupItem> items = [];
  //
  @override
  void initState() {
    //
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      items = group.items.where((e) {
        bool con1 = e.userData.name.contains(_controller.text);
        bool con2 = _controller.text.isEmpty;
        return con1 || con2;
      }).toList();
      setState(() {});
    });
    //
    //
    group = widget.group;
    items = group.items;
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentsGroupsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(group.name),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SendBulkNotificationView(
                    usersData: widget.group.items.map((e) {
                      return e.userData;
                    }).toList(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.notification_add),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: SizesResources.s2),
          MyTextFormFieldWidget(
            hintText: "بحث",
            suffix: const Icon(Icons.search),
            controller: _controller,
          ),
          const SizedBox(height: SizesResources.s2),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    StudentTileWidget(
                      userData: (items[index]).userData,
                      onLongPress: () {
                        showAlert(
                          context: context,
                          title: "ازالة طالب",
                          body:
                              "هل انت متاكد من رغبتك بازالة (${(items[index]).userData.name}) من المجموعة؟",
                          agreeBtn: "حذف",
                          onAgree: () {
                            //
                            cubit.deleteGroupItem(
                              groupId: group.id,
                              itemId: (items[index]).id,
                            );
                            //
                            setState(() {
                              group.items.removeWhere(
                                (e) => e.id == (items[index]).id,
                              );
                              //
                              items = group.items;
                              //
                            });
                            //
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
