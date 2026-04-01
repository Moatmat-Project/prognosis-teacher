import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CollegeFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isEditing;
  final VoidCallback onSubmit;

  const CollegeFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'اسم الكُلية',
              hintText: 'ادخل اسم الكُلية',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'رجاء ادخل اسم الكُلية';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'وصف الكُلية',
              hintText: 'ادخل وصف الكُلية',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'رجاء ادخل وصف الكُلية';
              }
              return null;
            },
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
            ),
            child: Text(
              isEditing ? 'Update College' : 'Add College',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
