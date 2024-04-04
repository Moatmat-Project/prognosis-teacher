import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hint,
    this.onChanged,
    this.initialValue,
    this.textInputAction,
    this.keyboardType,
    this.maxLines,
    this.minLines,
  });
  final String hint;
  final String? initialValue;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLines, minLines;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: TextFormField(
        minLines: minLines,
        textInputAction: textInputAction,
        onChanged: onChanged,
        keyboardType: keyboardType,
        initialValue: initialValue,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
