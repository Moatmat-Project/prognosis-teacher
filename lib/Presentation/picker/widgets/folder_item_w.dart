
import 'package:flutter/material.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';

class TextFolderItemWidget extends StatelessWidget {
  const TextFolderItemWidget({
    super.key,
    required this.name,
    this.onTap,
  });
  final String name;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          width: SpacingResources.mainWidth(context),
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
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s4,
                  horizontal: SizesResources.s2,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: SizesResources.s2),
                    //
                    const Icon(
                      Icons.folder,
                      color: ColorsResources.primary,
                    ),
                    //
                    const SizedBox(width: SizesResources.s2),
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(name),
                    ),
                    //
                    const Spacer(),
                    //
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}