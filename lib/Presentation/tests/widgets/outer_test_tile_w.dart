import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/shadows_r.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';

class OuterTestTileWidget extends StatelessWidget {
  const OuterTestTileWidget({super.key, required this.test, required this.onPick, this.isFolderItem = false});
  final OuterTest test;
  final bool isFolderItem;
  final VoidCallback onPick;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: isFolderItem ? MediaQuery.sizeOf(context).width : SpacingResources.mainWidth(context),
          margin: isFolderItem
              ? null
              : const EdgeInsets.symmetric(
                  vertical: SizesResources.s1,
                ),
          decoration: BoxDecoration(
            color: isFolderItem ? ColorsResources.background : ColorsResources.onPrimary,
            border: isFolderItem
                ? const Border(
                    bottom: BorderSide(color: ColorsResources.borders),
                  )
                : null,
            borderRadius: isFolderItem ? null : BorderRadius.circular(8),
            boxShadow: isFolderItem ? null : ShadowsResources.mainBoxShadow,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: InkWell(
              onTap: onPick,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SizesResources.s3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: SizesResources.s1),
                        Text(
                          test.information.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.blackText2,
                          ),
                        ),
                        const SizedBox(height: SizesResources.s1),
                        Text(
                          "عدد الاسئلة : ${test.information.length.toString()}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: ColorsResources.blackText2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "نوع الورقة : ${test.information.paperType.name}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: ColorsResources.blackText2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onPick,
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
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
