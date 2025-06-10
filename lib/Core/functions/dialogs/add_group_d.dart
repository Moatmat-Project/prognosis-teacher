import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/validators/not_empty_v.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';

import '../../constant/classes_list.dart';
import '../../resources/sizes_resources.dart';
import '../../widgets/fields/drop_down_w.dart';

addGroupDialog({
  required BuildContext context,
  required Function(String name, String classroom) onSave,
}) {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String classroom = classesLst.first;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("مجموعة جديدة"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextFormFieldWidget(
              width: SpacingResources.mainHalfWidth(context) * 1.25,
              hintText: "اسم المجموعة",
              onSaved: (p0) {
                name = p0 ?? "";
              },
              validator: (text) {
                return notEmptyValidator(text: text);
              },
            ),
            //
            const SizedBox(height: SizesResources.s2),
            //
            SizedBox(
              width: SpacingResources.mainHalfWidth(context) * 1.25,
              child: DropDownWidget(
                items: classesLst,
                selectedItem: classesLst.first,
                hintText: "الصف",
                onChanged: (p0) {
                  classroom = p0 ?? classroom;
                },
                onSaved: (p0) {},
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              onSave(name, classroom);
              Navigator.of(context).pop();
            }
          },
          child: const Text("إضافة"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("إلغاء"),
        ),
      ],
    ),
  );
}
