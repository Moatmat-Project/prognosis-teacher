import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/shadows_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Presentation/notifications/widgets/notification_form_widget.dart';
import 'package:moatmat_teacher/Presentation/notifications/widgets/send_notification_button_widget.dart';

class SendBulkNotificationBody extends StatelessWidget {
  const SendBulkNotificationBody({
    super.key,
    required this.formKey,
    required this.onSend,
    required this.titleController,
    required this.bodyController,
    required this.selectedImage,
    required this.onRemoveImage,
    required this.onPickImage,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onSend;
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final File? selectedImage;
  final VoidCallback onRemoveImage;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s2),
            const SizedBox(height: 8),
            if (selectedImage != null)
              Padding(
                padding: EdgeInsets.all(SpacingResources.sidePadding),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(selectedImage!,
                          height: 200, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsResources.dangerLight.withAlpha(50),
                          boxShadow: ShadowsResources.mainBoxShadow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: ColorsResources.danger,
                          tooltip: 'إزالة الصورة',
                          onPressed: onRemoveImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
         NotificationForm(isUserMode: false, titleController: titleController, bodyController: bodyController, pickImage: onPickImage),
            const SizedBox(height: SizesResources.s2),
            SendNotificationButton(onSend: onSend),
          ],
        ),
      ),
    );
  }
}
