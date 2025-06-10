import 'package:flutter/material.dart';

import '../resources/colors_r.dart';
import '../resources/fonts_r.dart';
import '../resources/shadows_r.dart';
import '../resources/sizes_resources.dart';
import '../resources/spacing_resources.dart';

class TouchableTileWidget extends StatelessWidget {
  const TouchableTileWidget({
    super.key,
    required this.title,
    this.iconData,
    this.onTap,
    this.subTitle,
    this.subTitle2,
    this.icon,
  });
  final String title;
  final String? subTitle;
  final String? subTitle2;
  final IconData? iconData;
  final Widget? icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
          width: SpacingResources.mainWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: ShadowsResources.mainBoxShadow,
            color: ColorsResources.onPrimary,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(SizesResources.s4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: FontsResources.styleLight().copyWith(
                            color: ColorsResources.blackText1,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        if (subTitle != null) ...[
                          const SizedBox(height: SizesResources.s2),
                          Text(
                            subTitle!,
                            textAlign: TextAlign.start,
                            style: FontsResources.styleRegular().copyWith(
                              color: ColorsResources.blackText2,
                              fontSize: 8,
                            ),
                          ),
                        ],
                        if (subTitle2 != null) ...[
                          const SizedBox(height: SizesResources.s2),
                          Text(
                            subTitle2!,
                            textAlign: TextAlign.start,
                            style: FontsResources.styleRegular().copyWith(
                              color: ColorsResources.blackText2,
                              fontSize: 8,
                            ),
                          ),
                        ]
                      ],
                    ),
                    Icon(
                      iconData,
                      color: ColorsResources.blackText2,
                      size: 8,
                    ),
                    if (icon != null) icon!,
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
