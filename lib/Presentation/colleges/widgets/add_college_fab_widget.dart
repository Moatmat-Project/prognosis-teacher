import 'package:flutter/material.dart';

class AddCollegeFabWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final int? schoolId;

  const AddCollegeFabWidget({
    super.key,
    required this.onPressed,
    this.schoolId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'اضافة كُلية',
      child: const Icon(Icons.add),
    );
  }
}
