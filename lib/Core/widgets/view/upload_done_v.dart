import 'package:flutter/material.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';

class UploadingDone extends StatelessWidget {
  const UploadingDone({super.key, required this.onTapButton});
  final VoidCallback onTapButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("تمت العملية بنجاح")),
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
