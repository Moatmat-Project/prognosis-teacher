import 'package:flutter/material.dart';

showAlert({
  required BuildContext context,
  required String title,
  required String body,
  required VoidCallback onAgree,
  VoidCallback? onDisagree,
  String? agreeBtn,
  String? disagreeBtn,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onAgree();
          },
          child: Text(agreeBtn ?? "حسنا"),
        ),
        TextButton(
          onPressed: () {
            if (onDisagree != null) {
              onDisagree();
            }
            Navigator.of(context).pop();
          },
          child: Text(disagreeBtn ?? "الغاء"),
        ),
      ],
    ),
  );
}
