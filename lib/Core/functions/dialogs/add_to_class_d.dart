import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Presentation/students/state/cubit/explore_class_students_cubit.dart';
import '../../constant/classes_list.dart';
import '../../services/classification_s.dart';
import '../../widgets/fields/drop_down_w.dart';

showAddToClass({
  required BuildContext context,
  required String uuid,
  required VoidCallback onSave,
}) {
  final s = ClassificationService();
  final formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("اضافة الى صف"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropDownWidget(
              selectedItem: s.getById(uuid)?.classs,
              items: classesLst,
              hintText: "الصف",
              onSaved: (p0) {
                ClassificationService().addUser(
                  UserClassData(
                    id: uuid,
                    classs: p0 ?? "",
                  ),
                );
                context.read<ExploreClassStudentsCubit>().init(classs: p0);
              },
              onChanged: (p0) {},
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              formKey.currentState?.save();
              onSave();
              Navigator.of(context).pop();
            }
          },
          child: const Text("حفظ"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("الغاء"),
        ),
      ],
    ),
  );
}
