import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/fonts_r.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Features/reports/domain/entities/reposrt_data.dart';

class ReportTileWidget extends StatelessWidget {
  const ReportTileWidget({
    super.key,
    required this.report,
    required this.onDelete,
    required this.onExploreTest,
    required this.onExploreBank,
  });
  final ReportData report;
  final VoidCallback onDelete;
  final VoidCallback onExploreTest;
  final VoidCallback onExploreBank;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: SizesResources.s3,
            horizontal: SizesResources.s3,
          ),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            boxShadow: ShadowsResources.mainBoxShadow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "رقم السؤال : ${report.questionID }",
                      style: FontsResources.styleMedium(size: 16),
                    ),
                    if (report.message != null && report.message != "") ...[
                      const SizedBox(height: SizesResources.s2),
                      Text(
                        "تفاصيل الابلاغ : ${report.message}",
                        style: FontsResources.styleRegular(size: 16),
                      ),
                    ],
                    const SizedBox(height: SizesResources.s1),
                    if (report.testId != null)
                      Text(
                        "اسم الأختبار : ${report.name}",
                        style: FontsResources.styleRegular(size: 14),
                      ),
                    if (report.bankId != null)
                      Text(
                        "اسم البنك : ${report.name}",
                        style: FontsResources.styleRegular(size: 12),
                      ),
                    const SizedBox(height: SizesResources.s1),
                    Text(
                      "اسم الطالب : ${report.userName}",
                      style: FontsResources.styleRegular(size: 14),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (report.testId != null)
                    TextButton(
                      onPressed: onExploreTest,
                      child: const Text("عرض السؤال"),
                    ),
                  if (report.bankId != null)
                    TextButton(
                      onPressed: onExploreBank,
                      child: const Text("عرض السؤال"),
                    ),
                  TextButton(
                    onPressed: () {
                      showAlert(
                        context: context,
                        title: "تاكيد الحذف",
                        body: "هل ترغب بحذف الابلاغ؟",
                        onAgree: onDelete,
                      );
                    },
                    child: const Text(
                      "حذف",
                      style: TextStyle(color: ColorsResources.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
