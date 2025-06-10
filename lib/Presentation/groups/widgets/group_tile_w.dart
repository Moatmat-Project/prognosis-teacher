import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/shadows_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';

class GroupTileWidget extends StatelessWidget {
  const GroupTileWidget({
    super.key,
    required this.group,
    this.onTap,
    this.onExploreSubscribers,
    this.onLongPress,
  });
  final Group group;
  final void Function()? onTap;
  final void Function()? onExploreSubscribers;
  final void Function()? onLongPress;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: ShadowsResources.mainBoxShadow,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: group.id != -1 ? onTap : onExploreSubscribers,
              onLongPress: group.id != -1 ? onLongPress : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SizesResources.s3,
                ),
                child: Row(
                  children: [
                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            group.name,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        //
                        if (group.id != -1)
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              "عدد الطلاب : ${group.items.length}",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    //
                    const Spacer(),
                    //
                    const Icon(Icons.arrow_forward_ios, size: 12)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
