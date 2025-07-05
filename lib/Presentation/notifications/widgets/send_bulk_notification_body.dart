import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/validators/not_empty_v.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Presentation/notifications/widgets/send_notification_button_widget.dart';

class SendBulkNotificationBody extends StatelessWidget {
  const SendBulkNotificationBody({
    super.key,
    required this.formKey,
    required this.onSend,
    required this.titleController,
    required this.bodyController,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onSend;
  final TextEditingController titleController;
  final TextEditingController bodyController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: SizesResources.s2),
          MyTextFormFieldWidget(
            hintText: "عنوان الإشعار",
            controller: titleController,
            validator: (p0) => notEmptyValidator(text: p0),
          ),
          const SizedBox(height: SizesResources.s2),
          MyTextFormFieldWidget(
            minLines: 1,
            maxLines: 5,
            hintText: "محتوى الإشعار",
            controller: bodyController,
            validator: (p0) => notEmptyValidator(text: p0),
          ),
          const SizedBox(height: SizesResources.s2),
          SendNotificationButton(onSend: onSend),
        ],
      ),
    );
  }
}
