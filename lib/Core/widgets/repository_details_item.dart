import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/functions/parsers/period_to_text_f.dart';

import '../resources/colors_r.dart';
import '../resources/shadows_r.dart';
import '../resources/sizes_resources.dart';
import '../resources/spacing_resources.dart';

class RepositoryDetailsItemWidget extends StatelessWidget {
  const RepositoryDetailsItemWidget({
    super.key,
    this.onTap,
    required this.averageMark,
     this.averageTime,
  });
  final String averageMark;
  final int? averageTime;
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
            borderRadius: BorderRadius.circular(12),
            boxShadow: ShadowsResources.mainBoxShadow,
            color: ColorsResources.onPrimary,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SizesResources.s6,
                  vertical: SizesResources.s4,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "المعدل العام",
                              style: TextStyle(
                                color: ColorsResources.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: SizesResources.s2),
                            Text(
                              averageMark,
                              style: const TextStyle(
                                color: ColorsResources.darkPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                          ],
                        ),
                        if (averageTime != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "الزمن العام",
                                style: TextStyle(
                                  color: ColorsResources.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: SizesResources.s2),
                              Text(
                                periodToTextFunction(averageTime!),
                                style: const TextStyle(
                                  color: ColorsResources.darkPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                    //
                    const SizedBox(height: SizesResources.s3),
                    //
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "نسب الاختيارات",
                              style: TextStyle(
                                color: ColorsResources.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: SizesResources.s1),
                            InkWell(
                              onTap: onTap,
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 3),
                                    child: Text(
                                      "عرض نسب اختيار الطلاب للاجبات",
                                      style: TextStyle(
                                        color: ColorsResources.darkPrimary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizesResources.s1),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10,
                                    color: ColorsResources.darkPrimary,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
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
