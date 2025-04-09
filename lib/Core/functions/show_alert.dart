import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      content: Text(body),
      actionsPadding: EdgeInsets.all(8),
      actions: [
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.all(10)),
          onPressed: () {
            if (onDisagree != null) {
              onDisagree();
            }
            Navigator.of(context).pop();
          },
          child: Text(
            disagreeBtn ?? "إلغاء",
            style: TextStyle(
              color: ColorsResources.blackText2,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.all(10)),
          onPressed: () {
            Navigator.of(context).pop();
            onAgree();
          },
          child: Text(
            agreeBtn ?? "حسنا",
            style: TextStyle(
              color: ColorsResources.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
