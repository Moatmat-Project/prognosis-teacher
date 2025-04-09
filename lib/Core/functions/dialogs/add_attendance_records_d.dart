import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_teacher/Core/validators/numbers_v.dart';

import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';
import '../../services/folders_s.dart';
import '../../widgets/fields/elevated_button_widget.dart';
import '../../widgets/fields/text_input_field.dart';

addAttendanceRecordsFunction({
  required BuildContext context,
  required Function(String) onAdd,
}) {
  String name = "";
  final formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) {
      return Form(
        key: formKey,
        child: Dialog(
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: SizesResources.s4),
              const Text("اضافة سجل حضور"),
              const SizedBox(height: SizesResources.s4),
              MyTextFormFieldWidget(
                hintText: "معرف الطالب",
                width: SpacingResources.mainHalfWidth(context),
                keyboardType: TextInputType.number,
                validator: (p0) {
                  return numbersValidator(p0);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (p0) {
                  name = p0 ?? '';
                },
              ),
              const SizedBox(height: SizesResources.s4),
              ElevatedButtonWidget(
                text: "إضافة",
                width: SpacingResources.mainHalfWidth(context),
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    onAdd(name);
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(height: SizesResources.s4),
            ],
          ),
        ),
      );
    },
  );
}
