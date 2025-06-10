import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/fonts_r.dart';
import 'package:moatmat_teacher/Core/resources/shadows_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Features/purchase/domain/entities/purchase_item.dart';

class PurchasesInformation extends StatelessWidget {
  const PurchasesInformation({super.key, required this.items});
  final List<PurchaseItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          padding: const EdgeInsets.symmetric(
            vertical: SizesResources.s3,
            horizontal: SizesResources.s3,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s2,
          ),
          decoration: BoxDecoration(
            boxShadow: ShadowsResources.mainBoxShadow,
            borderRadius: BorderRadius.circular(10),
            color: ColorsResources.onPrimary,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عدد عمليات الشراء',
                    style: FontsResources.styleMedium(),
                  ),
                  Text(
                    
                    "${items.length}",
                    style: FontsResources.styleExtraBold(
                      color: ColorsResources.darkPrimary,
                    ),
                  ),
                ],
              ),
              //
              const SizedBox(height: SizesResources.s2),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'صافي مبلغ الشراء',
                    style: FontsResources.styleMedium(),
                  ),
                  Text(
                    "${amount()}",
                    style: FontsResources.styleExtraBold(
                      color: ColorsResources.darkPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  int amount() {
    int sum = 0;
    for (var i in items) {
      sum += i.amount;
    }
    return sum;
  }
}
