import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Presentation/purchases/state/cubit/purchases_cubit.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/fonts_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Features/purchase/domain/entities/purchase_item.dart';

class PurchasesView extends StatefulWidget {
  const PurchasesView({super.key});

  @override
  State<PurchasesView> createState() => _PurchasesViewState();
}

class _PurchasesViewState extends State<PurchasesView> {
  @override
  void initState() {
    context.read<PurchasesCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تفاصيل الاشتراكات",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: BlocBuilder<PurchasesCubit, PurchasesState>(
        builder: (context, state) {
          if (state is PurchasesInitial) {
            return Column(
              children: [
                TeacherPurchasesInformation(
                  items: state.purchases,
                ),
                const SizedBox(height: SizesResources.s2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: SpacingResources.mainWidth(context),
                      child: const Text("سجل الاشتراكات :"),
                    ),
                  ],
                ),
                const SizedBox(height: SizesResources.s2),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.purchases.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: SpacingResources.mainWidth(context),
                            margin: const EdgeInsets.symmetric(
                              vertical: SizesResources.s1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: SizesResources.s3,
                              vertical: SizesResources.s3,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsResources.onPrimary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: ShadowsResources.mainBoxShadow,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (state.purchases[index].userName.isNotEmpty)
                                        Text(
                                          "اسم : ${state.purchases[index].userName}",
                                        ),
                                      Text(
                                        "المبلغ : ${state.purchases[index].amount}",
                                      ),
                                      Text(
                                        "يوم/شهر : ${state.purchases[index].dayAndMoth}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}

class TeacherPurchasesInformation extends StatelessWidget {
  const TeacherPurchasesInformation({super.key, required this.items});
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
                    'عدد عمليات الاشتراك',
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
                    'صافي مبلغ الاشتراكات',
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
