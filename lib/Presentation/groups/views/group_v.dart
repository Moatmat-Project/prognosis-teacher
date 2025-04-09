import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/constant/classes_list.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';
import 'package:moatmat_teacher/Presentation/groups/views/manage_group_tests_view.dart';
import 'package:moatmat_teacher/Presentation/notifications/views/send_bulk_notification_v.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../statistics/views/export_students_statistics_view.dart';
import '../../students/views/my_students_v.dart';
import '../../students/views/students_statistics_v.dart';
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
        title: Text(group.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SendBulkNotificationView(
                    usersData: widget.group.items.map((e) => e.userData).toList(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.notification_add),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => ExportStudentsStatisticsView(
                    students: widget.group.items.map((e) => e.userData).toList(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.insert_chart),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            toolbarHeight: 135,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(SizesResources.s2),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: MyTextFormFieldWidget(
                      hintText: "بحث",
                      suffix: const Icon(Icons.search),
                      controller: _controller,
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    width: SpacingResources.mainWidth(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsResources.primary.withAlpha(50),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(7),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ManageGroupTestsView(
                                  group: group,
                                  isCourseSubscribersGroup: false,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  color: ColorsResources.primary,
                                  size: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3, right: 8),
                                  child: Text(
                                    "ادارة اختبارات المجموعة",
                                    style: TextStyle(
                                      color: ColorsResources.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // List of students
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return StudentTileWidget(
                  userData: items[index].userData,
                  onLongPress: () {
                    showAlert(
                      context: context,
                      title: "ازالة طالب",
                      body: "هل انت متأكد من رغبتك بإزالة (${items[index].userData.name}) من المجموعة؟",
                      agreeBtn: "حذف",
                      onAgree: () {
                        cubit.deleteGroupItem(
                          groupId: group.id,
                          itemId: items[index].id,
                        );
                        setState(() {
                          group.items.removeWhere((e) => e.id == items[index].id);
                          items = group.items;
                        });
                      },
                    );
                  },
                );
              },
              childCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  SearchBarDelegate({required this.controller});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double visibleHeight = maxExtent - shrinkOffset; // Dynamically reduce height
    visibleHeight = visibleHeight.clamp(minExtent, maxExtent); // Keep within range

    return Opacity(
      opacity: visibleHeight / maxExtent, // Fade out as it shrinks
      child: Container(
        height: visibleHeight,
        padding: const EdgeInsets.all(SizesResources.s2),
        child: MyTextFormFieldWidget(
          hintText: "بحث",
          suffix: const Icon(Icons.search),
          controller: controller,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60; // Full height when expanded
  @override
  double get minExtent => 30; // Partially visible when collapsed
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
