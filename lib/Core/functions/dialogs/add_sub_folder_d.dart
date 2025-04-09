import 'package:flutter/material.dart';

import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';
import '../../services/folders_s.dart';
import '../../widgets/fields/elevated_button_widget.dart';
import '../../widgets/fields/text_input_field.dart';

addSubFolderFunction({
  required BuildContext context,
  required Function(String) onAdd,
}) {
  String name = "";
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: SizesResources.s4),
            const Text("مجلد جديد"),
            const SizedBox(height: SizesResources.s4),
            MyTextFormFieldWidget(
              hintText: "اسم المجلد",
              width: SpacingResources.mainHalfWidth(context),
              onChanged: (p0) {
                name = p0 ?? '';
              },
            ),
            const SizedBox(height: SizesResources.s4),
            ElevatedButtonWidget(
              text: "إضافة",
              width: SpacingResources.mainHalfWidth(context),
              onPressed: () {
                onAdd(name);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: SizesResources.s4),
          ],
        ),
      );
    },
  );
}
