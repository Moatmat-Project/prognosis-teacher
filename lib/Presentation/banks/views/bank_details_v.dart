import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Presentation/banks/state/my_banks/my_banks_cubit.dart';
import 'package:moatmat_teacher/Presentation/banks/views/add_bank_view.dart';
import 'package:moatmat_teacher/Presentation/banks_results/views/bank_results_v.dart';
import 'package:moatmat_teacher/Presentation/folders/state/folders_manager/folders_manager_cubit.dart';

import '../../../Core/functions/dialogs/add_item_to_folder.dart';
import '../../../Core/functions/show_alert.dart';
import '../../../Core/injection/app_inj.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/services/folders_s.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';
import '../../../Features/auth/domain/entites/teacher_data.dart';
import '../../export/views/questions/export_questions_v.dart';
import '../../folders/view/add_item_to_folder_v.dart';
import '../../groups/views/group_test_details_v.dart';
import '../../tests/widgets/purchases_informations_w.dart';
import '../state/bank_information/bank_information_cubit.dart';

class BankDetailsView extends StatefulWidget {
  const BankDetailsView({
    super.key,
    this.bank,
    this.bankId,
  });

  final Bank? bank;
  final int? bankId;

  @override
  State<BankDetailsView> createState() => _BankDetailsViewState();
}

class _BankDetailsViewState extends State<BankDetailsView> {
  @override
  void initState() {
    context.read<BankInformationCubit>().init(
          bank: widget.bank,
          bankId: widget.bankId,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BankInformationCubit, BankInformationState>(
        builder: (context, state) {
          if (state is BankInformationInitial) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.bank.information.title),
                actions: [
                  IconButton(
                    onPressed: () {
                      if (!locator<TeacherData>().options.allowDelete) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مصرح لك بالحذف"),
                          ),
                        );
                        return;
                      }
                      showAlert(
                        context: context,
                        title: "تأكيد",
                        body: "هل انت متاكد من انك تريد حذف البنك",
                        onAgree: () {
                          context.read<MyBanksCubit>().deleteBank(state.bank);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),

                  //
                  const SizedBox(width: SizesResources.s2),
                  //
                  IconButton(
                    onPressed: () async {
                      //
                      if (!locator<TeacherData>().options.allowUpdate) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                        return;
                      }
                      //
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddBankView(
                          bank: widget.bank,
                        ),
                      ));
                      //
                      if (mounted) {
                        context.read<MyBanksCubit>().init();
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                  )
                ],
              ),
              body: Column(
                children: [
                  TouchableTileWidget(
                    title: "تعديل",
                    iconData: Icons.edit,
                    onTap: () async {
                      if (locator<TeacherData>().options.allowUpdate) {
                        //
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddBankView(
                            bank: state.bank,
                          ),
                        ));
                        //
                        if (mounted) {
                          context.read<MyBanksCubit>().init();
                          Navigator.of(context).pop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  TouchableTileWidget(
                    title: "إضافة البنك إلى مجلد",
                    iconData: Icons.edit,
                    onTap: () async {
                      if (locator<TeacherData>().options.allowUpdate) {
                        //
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddItemToFolderView(
                              id: state.bank.id,
                              isTest: false,
                              teacherEmail: locator<TeacherData>().email,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  TouchableTileWidget(
                    title: "تفاصيل مجموعات الطلاب",
                    iconData: Icons.people,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GroupTestDetailsView(
                            bank: state.bank,
                          ),
                        ),
                      );
                    },
                  ),
                  TouchableTileWidget(
                    title: "حذف",
                    iconData: Icons.delete,
                    onTap: () {
                      if (locator<TeacherData>().options.allowDelete) {
                        showAlert(
                          context: context,
                          title: "تأكيد",
                          body: "هل انت متاكد من انك تريد حذف الاختبار",
                          onAgree: () {
                            context.read<MyBanksCubit>().deleteBank(state.bank);
                            Navigator.of(context).pop();
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("غير مسموح بالعملية"),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: SpacingResources.mainWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TouchableTileWidget(
                          title: "تصفح نتائج البنك",
                          iconData: Icons.arrow_forward_ios,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BankResultsView(
                                  bank: state.bank,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SpacingResources.mainWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TouchableTileWidget(
                          title: "تصدير الاختبار",
                          iconData: Icons.arrow_forward_ios,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExportQuestionsView(
                                  questions: state.bank.questions,
                                  title: state.bank.information.title,
                                  teacher: state.bank.information.teacher,
                                  period: null,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  PurchasesInformation(
                    items: state.items,
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: SpacingResources.mainWidth(context), child: const Text("عمليات الشراء :")),
                    ],
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
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
                                        if (state.items[index].userName.isNotEmpty)
                                          Text(
                                            "اسم الطالب : ${state.items[index].userName}",
                                          ),
                                        Text(
                                          "المبلغ : ${state.items[index].amount}",
                                        ),
                                        Text(
                                          "يوم/شهر : ${state.items[index].dayAndMoth}",
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
              ),
            );
          } else if (state is BankInformationError) {
            return Center(
              child: Text(state.message ?? ""),
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
