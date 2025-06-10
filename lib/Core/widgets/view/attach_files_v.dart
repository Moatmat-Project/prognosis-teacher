import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';

import '../../functions/coders/decode.dart';
import '../../resources/colors_r.dart';
import '../../resources/shadows_r.dart';
import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';
import '../fields/attachment_w.dart';

class AttachFilesView extends StatefulWidget {
  const AttachFilesView({
    super.key,
    required this.type,
    required this.assets,
    required this.onSave,
  });
  final FileType type;
  final List<String> assets;
  final Function(List<String> assets) onSave;
  @override
  State<AttachFilesView> createState() => _AttachFilesViewState();
}

class _AttachFilesViewState extends State<AttachFilesView> {
  List<String> assets = [];
  //

  //
  pickFiles() async {
    //
    await requestPermissions();
    //
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: widget.type,
    );
    //
    if (result != null) {
      assets += result.files.map((e) {
        return e.path ?? "";
      }).where((e) {
        return e.isNotEmpty;
      }).toList();
    }
    //
    setState(() {});
  }

  @override
  void initState() {
    assets = widget.assets;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ارفاق ملفات"),
        actions: [
          TextButton(
            onPressed: pickFiles,
            child: const Text("إضافة"),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButtonWidget(
              text: "حفظ التغييرات",
              onPressed: () {
                widget.onSave(assets);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: widget.type == FileType.image
          ? GridView.builder(
              padding: const EdgeInsets.all(SizesResources.s2),
              itemCount: assets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 1,
                mainAxisSpacing: SizesResources.s2,
                crossAxisSpacing: SizesResources.s2,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        File(assets[index]),
                        fit: BoxFit.fill,
                        width: 500,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.4),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            assets.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: ColorsResources.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
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
                            child: Text(decodeFileName(assets[index].split("/").last)),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                assets.removeAt(index);
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
    );
  }
}
