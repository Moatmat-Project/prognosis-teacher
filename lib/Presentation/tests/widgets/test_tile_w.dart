import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/shadows_r.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/tests/domain/entities/test/test.dart';

class TestTileWidget extends StatelessWidget {
  const TestTileWidget({super.key, required this.test, required this.onPick, this.isFolderItem = false});
  final Test test;
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
                        Text(
                          test.information.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ColorsResources.blackText2,
                          ),
                        ),
                        Text(
                          "${test.questions.length.toString()} سؤال",
                          style: const TextStyle(
                            fontSize: 10,
                            color: ColorsResources.blackText2,
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

  Widget getSubTitle() {
    if (test.information.password != null && test.information.password!.isNotEmpty) {
      return const Text(
        "كلمة السر مطلوبة",
        style: TextStyle(
          fontSize: 10,
          color: ColorsResources.darkPrimary,
        ),
      );
    }
    return const Text(
      "كلمة السر غير مطلوبة",
      style: TextStyle(
        fontSize: 10,
        color: ColorsResources.borders,
      ),
    );
  }
}
