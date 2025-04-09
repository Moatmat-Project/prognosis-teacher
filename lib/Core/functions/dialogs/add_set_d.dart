import 'package:flutter/material.dart';

import '../../resources/colors_r.dart';

addSetDialog({required BuildContext context, required dynamic Function(String) onSubmit, String? initialTitle}) {
  showDialog(
    context: context,
    builder: (context) {
      return CreateSetDialog(
        initialTitle: initialTitle,
        onSubmit: onSubmit,
      );
    },
  );
}

class CreateSetDialog extends StatefulWidget {
  final String? initialTitle;
  final Function(String) onSubmit;
  const CreateSetDialog({super.key, required this.onSubmit, this.initialTitle});

  @override
  State<CreateSetDialog> createState() => _CreateSetDialogState();
}

class _CreateSetDialogState extends State<CreateSetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  @override
  void initState() {
    _titleController = TextEditingController(text: widget.initialTitle);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTitle == null ? 'إنشاء جلسة جديدة' : 'تعديل الجلسة'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'عنوان الجلسة',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال عنوان الجلسة';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'إلغاء',
            style: TextStyle(
              color: ColorsResources.blackText1,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(_titleController.text);
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.initialTitle == null ? 'إنشاء' : 'حفظ'),
        ),
      ],
    );
  }
}
