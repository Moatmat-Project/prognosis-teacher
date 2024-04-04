import 'package:flutter/cupertino.dart';

class CheckingWidget extends StatelessWidget {
  const CheckingWidget({
    super.key,
    required this.title,
    this.value, this.onChanged,
  });
  final String title;
  final bool? value;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 4.0,
      ),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          CupertinoCheckbox(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
