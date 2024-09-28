import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_question.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test_form.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test_information.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'package:moatmat_teacher/Presentation/tests/state/add_outer_test/add_outer_test_cubit.dart';

import '../../../Core/constant/classes_list.dart';
import '../../../Core/constant/materials.dart';
import '../../../Core/functions/parsers/date_to_text_f.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/validators/not_empty_v.dart';
import '../../../Core/validators/numbers_v.dart';
import '../../../Core/widgets/fields/drop_down_w.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../../../Core/widgets/toucheable_tile_widget.dart';

class SetOuterTestInformationView extends StatefulWidget {
  const SetOuterTestInformationView({
    super.key,
    this.information,
    required this.forms,
  });
  final List<OuterTestForm> forms;
  final OuterTestInformation? information;
  @override
  State<SetOuterTestInformationView> createState() => _SetOuterTestInformationViewState();
}

class _SetOuterTestInformationViewState extends State<SetOuterTestInformationView> {
  //
  late int formsLength;
  //
  final _formKey = GlobalKey<FormState>();
  //
  late PaperType paperType;
  //
  late int? length;
  //
  late String? title, teacher, classs, material;
  //
  late DateTime date;
  //
  @override
  void initState() {
    formsLength = widget.forms.length;
    paperType = widget.information?.paperType ?? PaperType.A4;
    title = widget.information?.title;
    teacher = widget.information?.teacher;
    classs = widget.information?.classs ?? classesLst[classesLst.length - 2];
    material = widget.information?.material ?? materialsLst.first["name"]!;
    length = widget.information?.length;
    date = widget.information?.date ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text('تحديد معلومات الاختبار'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s4),
            //
            MyTextFormFieldWidget(
              initialValue: title,
              hintText: "اسم الاختبار",
              validator: (v) {
                return notEmptyValidator(text: v);
              },
              onChanged: (p0) {
                title = p0;
              },
            ),
            const SizedBox(height: SizesResources.s2),
            DropDownWidget(
              hintText: "الصف",
              selectedItem: classs ?? classesLst[classesLst.length - 2],
              items: classesLst,
              validator: (p0) {
                return notEmptyValidator(text: p0);
              },
              onSaved: (p0) {
                classs = p0;
              },
            ),
            const SizedBox(height: SizesResources.s2),
            DropDownWidget(
              hintText: "المادة",
              selectedItem: material ?? materialsLst.first["name"],
              items: materialsLst.map((e) => e["name"] as String).toList(),
              validator: (p0) {
                return notEmptyValidator(text: p0);
              },
              onSaved: (p0) {
                material = p0;
              },
            ),
            //
            const SizedBox(height: SizesResources.s4),
            //
            MyTextFormFieldWidget(
              hintText: "عدد الاسئلة",
              initialValue: length?.toString(),
              validator: (p0) {
                if (p0?.isNotEmpty ?? false) {
                  switch (paperType) {
                    case PaperType.A4:
                      if ((int.tryParse(p0!) ?? 0) > 100) {
                        return "لا يمكن ان يكون عدد الاسئلة اكبر من 100 سؤال";
                      }
                    case PaperType.A5:
                      if ((int.tryParse(p0!) ?? 0) > 50) {
                        return "لا يمكن ان يكون عدد الاسئلة اكبر من 50 سؤال";
                      }
                    case PaperType.A6:
                      if ((int.tryParse(p0!) ?? 0) > 30) {
                        return "لا يمكن ان يكون عدد الاسئلة اكبر من 30 سؤال";
                      }
                  }
                }
                return numbersValidator(p0);
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSaved: (p0) {
                length = int.parse(p0!);
              },
            ),
            //
            const SizedBox(height: SizesResources.s4),
            //
            TouchableTileWidget(
              title: "التاريخ : ${date.year}/${dateToTextFunction(date)}",
              onTap: () async {
                final res = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(
                    const Duration(days: 7),
                  ),
                  initialDate: date,
                  lastDate: DateTime.now().add(
                    const Duration(days: 7),
                  ),
                  onDatePickerModeChange: (value) {},
                );
                if (res != null) {
                  setState(() {
                    date = res;
                  });
                }
              },
            ),
            //
            const SizedBox(height: SizesResources.s4),
            //
            DropDownWidget(
              hintText: "نوع الموذج",
              selectedItem: paperType.name,
              items: PaperType.values.map((e) => e.name).toList(),
              onChanged: (p0) {
                switch (p0) {
                  case "A4":
                    paperType = PaperType.A4;
                    break;
                  case "A5":
                    paperType = PaperType.A5;
                    break;
                  case "A6":
                    paperType = PaperType.A6;
                    break;
                  default:
                    paperType = PaperType.A4;
                    break;
                }
                _formKey.currentState?.validate();
              },
              onSaved: (p0) {
                paperType = PaperType.values.firstWhere(
                  (element) => element.name == p0,
                );
              },
            ),
            //
            const SizedBox(height: SizesResources.s4),
            //

            const SizedBox(height: SizesResources.s4),
            //
            DropDownWidget(
              hintText: "عدد النماذج",
              selectedItem: (formsLength).toString(),
              items: const ["1", "2", "3", "4"],
              validator: (p0) {
                if (!["1", "2", "3", "4"].contains(p0)) {
                  return "يجب اختيار عدد النماذج";
                }
                return notEmptyValidator(text: p0);
              },
              onChanged: (p0) {
                switch (p0) {
                  case "1":
                    setState(() {
                      formsLength = 1;
                    });
                    break;
                  case "2":
                    setState(() {
                      formsLength = 2;
                    });
                    break;
                  case "3":
                    setState(() {
                      formsLength = 3;
                    });
                    break;
                  case "4":
                    setState(() {
                      formsLength = 4;
                    });
                    break;
                  default:
                    setState(() {
                      formsLength = 1;
                    });
                    break;
                }
                _formKey.currentState?.validate();
              },
              onSaved: (p0) {},
            ),
            //
            const SizedBox(height: SizesResources.s4),
            //
            ElevatedButtonWidget(
              text: "متابعة",
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  //
                  _formKey.currentState?.save();
                  //
                  context.read<AddOuterTestCubit>().setInformation(
                        OuterTestInformation(
                          title: title!,
                          teacher: locator<TeacherData>().email,
                          material: material!,
                          classs: classs!,
                          date: date,
                          length: length!,
                          paperType: paperType,
                        ),
                        List.generate(
                          formsLength,
                          (index) {
                            return OuterTestForm(
                              id: index,
                              questions: List.generate(
                                length!,
                                (index) => OuterQuestion(id: index, trueAnswer: 0),
                              ),
                            );
                          },
                        ),
                      );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
