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
    this.onTap, this.onLongPress,
  });
  final Group group;
  final void Function()? onTap;
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
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SizesResources.s3,
                ),
                child: Row(
                  children: [
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(group.name),
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
