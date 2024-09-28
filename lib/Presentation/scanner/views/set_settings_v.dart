import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/parsers/date_to_text_f.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/validators/not_empty_v.dart';
import 'package:moatmat_teacher/Core/validators/numbers_v.dart';
import 'package:moatmat_teacher/Core/widgets/fields/drop_down_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Presentation/scanner/state/scanner_views_manager_cubit.dart';

import '../../../Features/scanner/domain/entities/paper.dart';

class ScannerSetSettingsView extends StatefulWidget {
  const ScannerSetSettingsView({
    super.key,
  });
  @override
  State<ScannerSetSettingsView> createState() => _ScannerSetSettingsViewState();
}

class _ScannerSetSettingsViewState extends State<ScannerSetSettingsView> {
  //
  // final _formKey = GlobalKey<FormState>();
  // //
  // late int? length;
  // //
  // late int? formsCount;
  // //
  // late String? title;
  // //
  // late DateTime date;
  // //
  // late PaperType paperType;
  // //
  // @override
  // void initState() {
  //   //
  //   length = widget.state.settings?.answers.length;
  //   //
  //   formsCount = widget.state.settings?.formsCount ?? 1;
  //   //
  //   title = widget.state.settings?.title;
  //   //
  //   date = widget.state.settings?.date ?? DateTime.now();
  //   //
  //   paperType = widget.state.settings?.type ?? PaperType.A4;
  //   //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("معلومات الاختبار"),
      ),
      // body: Form(
      //   key: _formKey,
      //   child: Column(
      //     children: [
      //       //
      //       const SizedBox(height: SizesResources.s4),
      //       //
      //       MyTextFormFieldWidget(
      //         initialValue: title,
      //         hintText: "اسم الاختبار",
      //         validator: (v) {
      //           return notEmptyValidator(text: v);
      //         },
      //         onChanged: (p0) {
      //           title = p0;
      //         },
      //       ),
      //       //
      //       const SizedBox(height: SizesResources.s4),
      //       //
      //       MyTextFormFieldWidget(
      //         hintText: "عدد الاسئلة",
      //         validator: (p0) {
      //           if (p0?.isNotEmpty ?? false) {
      //             switch (paperType) {
      //               case PaperType.A4:
      //                 if ((int.tryParse(p0!) ?? 0) > 100) {
      //                   return "لا يمكن ان يكون عدد الاسئلة اكبر من 100 سؤال";
      //                 }
      //               case PaperType.A5:
      //                 if ((int.tryParse(p0!) ?? 0) > 50) {
      //                   return "لا يمكن ان يكون عدد الاسئلة اكبر من 50 سؤال";
      //                 }
      //               case PaperType.A6:
      //                 if ((int.tryParse(p0!) ?? 0) > 30) {
      //                   return "لا يمكن ان يكون عدد الاسئلة اكبر من 30 سؤال";
      //                 }
      //             }
      //           }
      //           return numbersValidator(p0);
      //         },
      //         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      //         onSaved: (p0) {
      //           length = int.parse(p0!);
      //         },
      //       ),
      //       //
      //       const SizedBox(height: SizesResources.s4),
      //       //
      //       TouchableTileWidget(
      //         title: "التاريخ : ${date.year}/${dateToTextFunction(date)}",
      //         onTap: () async {
      //           final res = await showDatePicker(
      //             context: context,
      //             firstDate: DateTime.now().subtract(
      //               const Duration(days: 7),
      //             ),
      //             initialDate: date,
      //             lastDate: DateTime.now().add(
      //               const Duration(days: 7),
      //             ),
      //             onDatePickerModeChange: (value) {},
      //           );
      //           if (res != null) {
      //             setState(() {
      //               date = res;
      //             });
      //           }
      //         },
      //       ),
      //       //
      //       const SizedBox(height: SizesResources.s4),
      //       //
      //       DropDownWidget(
      //         hintText: "نوع الموذج",
      //         selectedItem: paperType.name,
      //         items: PaperType.values.map((e) => e.name).toList(),
      //         onChanged: (p0) {
      //           switch (p0) {
      //             case "A4":
      //               paperType = PaperType.A4;
      //               break;
      //             case "A5":
      //               paperType = PaperType.A5;
      //               break;
      //             case "A6":
      //               paperType = PaperType.A6;
      //               break;
      //             default:
      //               paperType = PaperType.A4;
      //               break;
      //           }
      //           _formKey.currentState?.validate();
      //         },
      //         onSaved: (p0) {},
      //       ),
      //       const SizedBox(height: SizesResources.s4),
      //       //
      //       DropDownWidget(
      //         hintText: "عدد النماذج",
      //         selectedItem: formsCount.toString(),
      //         items: const ["1", "2", "3", "4"],
      //         onChanged: (p0) {
      //           switch (p0) {
      //             case "1":
      //               formsCount = 1;
      //               break;
      //             case "2":
      //               formsCount = 2;
      //               break;
      //             case "3":
      //               formsCount = 3;
      //               break;
      //             case "4":
      //               formsCount = 4;
      //               break;
      //             default:
      //               formsCount = 1;
      //               break;
      //           }
      //           _formKey.currentState?.validate();
      //         },
      //         onSaved: (p0) {},
      //       ),
      //       //
      //       const SizedBox(height: SizesResources.s4),
      //       //
      //       ElevatedButtonWidget(
      //         text: "متابعة",
      //         onPressed: () {
      //           if (_formKey.currentState?.validate() ?? false) {
      //             //
      //             _formKey.currentState?.save();
      //             //
      //             context.read<ScannerViewsManagerCubit>().setSettings(
      //                   PaperSettings(
      //                     title: title!,
      //                     date: date,
      //                     type: paperType,
      //                     selections: [],
      //                     formsCount: formsCount!,
      //                     answers: List.filled(
      //                       formsCount!,
      //                       List.filled(length!, 0),
      //                     ),
      //                   ),
      //                 );
      //             //
      //             context.read<ScannerViewsManagerCubit>().showAnswers();
      //           }
      //         },
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
