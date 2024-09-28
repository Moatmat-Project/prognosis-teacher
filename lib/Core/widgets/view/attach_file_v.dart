import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';

import '../../resources/colors_r.dart';
import '../../resources/shadows_r.dart';
import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';
import '../fields/attachment_w.dart';
import '../fields/elevated_button_widget.dart';

class AttachFileView extends StatefulWidget {
  const AttachFileView({
    super.key,
    required this.onPop,
    required this.onFinish,
    required this.onUpdate,
    this.text,
    this.files,
  });
  final String? text;
  final List<String>? files;
  final VoidCallback onPop;
  final VoidCallback onFinish;
  final Function(String, List<String>) onUpdate;
  @override
  State<AttachFileView> createState() => _AttachFileViewState();
}

class _AttachFileViewState extends State<AttachFileView> {
  late String text;
  late List<PlatformFile> files;
  //
  @override
  void initState() {
    text = widget.text ?? "";
    //
    files = [];
    //
    if (widget.files != null) {
      for (var f in widget.files!) {
        files.add(
          PlatformFile(
            name: f.split("/").last,
            size: 0,
            path: f,
          ),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('تجهيز طلب الرفع'),
        actions: [
          IconButton(
            onPressed: widget.onPop,
            icon: const Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
      body: Column(
        children: [
          //
          const SizedBox(height: SizesResources.s2),
          //
          MyTextFormFieldWidget(
            hintText: "ارفاق نص",
            minLines: 1,
            maxLines: 5,
            onChanged: (p0) {
              text = p0 ?? "";
              widget.onUpdate(text, files.map((e) => e.path ?? "").toList());
            },
          ),
          //
          const SizedBox(height: SizesResources.s4),
          //
          ElevatedButtonWidget(
            text: "اضافة ملفات",
            onPressed: () async {
              //
              await requestPermissions();
              //
              final result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.any,
              );
              //
              if (result != null) {
                files += result.files;
              }
              //
              widget.onUpdate(text, files.map((e) => e.path ?? "").toList());
              //
              setState(() {});
            },
          ),
          //
          const SizedBox(height: SizesResources.s4),
          //
          Expanded(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                //
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: SizesResources.s1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: SizesResources.s1,
                        horizontal: SizesResources.s2,
                      ),
                      width: SpacingResources.mainWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: ShadowsResources.mainBoxShadow,
                        color: ColorsResources.onPrimary,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(files[index].name),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                files.removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: ColorsResources.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "تحميل و وارسال",
          onPressed: () async {
            widget.onFinish();
          },
        ),
      ),
    );
  }
}
