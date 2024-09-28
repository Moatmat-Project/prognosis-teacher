import 'package:flutter/material.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';

class UploadingError extends StatelessWidget {
  const UploadingError({
    super.key,
    required this.msg,
    required this.onTapButton,
  });
  final String msg;
  final VoidCallback onTapButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "العودة",
          onPressed: onTapButton,
        ),
      ),
    );
  }
}
