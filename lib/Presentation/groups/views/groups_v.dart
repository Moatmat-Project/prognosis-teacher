import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/constant/classes_list.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Presentation/groups/state/groups/students_groups_cubit.dart';
import 'package:moatmat_teacher/Presentation/groups/widgets/group_tile_w.dart';
import 'package:moatmat_teacher/Presentation/students/views/explore_class_students_v.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Features/groups/domain/entities/group.dart';

class GroupsView extends StatefulWidget {
  const GroupsView({
    super.key,
    required this.groups,
    required this.onTap,
  });
  //
  final List<Group> groups;
  final Function(int index) onTap;

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  String? classRoom;

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: SizesResources.s2),
          SizedBox(
            height: 50,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: SizesResources.s2,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: classesLst.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: SizesResources.s1,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsResources.onPrimary,
                        boxShadow: ShadowsResources.mainBoxShadow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExploreClassStudentsView(
                                  classs: classesLst[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(
                              SizesResources.s2,
                            ),
                            child: Text(
                              classesLst[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: SizesResources.s1),
          Expanded(
            child: ListView.builder(
              itemCount: widget.groups.length,
              itemBuilder: (context, index) {
                return GroupTileWidget(
                  group: widget.groups[index],
                  onLongPress: () {
                    showAlert(
                      context: context,
                      title: "حذف مجموعة ${widget.groups[index].name}",
                      body: "هل انت متاكد من رغبتك بحذف المجموعة؟",
                      agreeBtn: "حذف",
                      onAgree: () {
                        context.read<StudentsGroupsCubit>().deleteGroup(
                              groupId: widget.groups[index].id,
                            );
                      },
                    );
                  },
                  onTap: () {
                    widget.onTap(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
