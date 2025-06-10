import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../resources/colors_r.dart';
import '../../resources/fonts_r.dart';
import '../../resources/shadows_r.dart';
import '../../resources/sizes_resources.dart';
import '../../resources/spacing_resources.dart';

class AttachmentWidget extends StatefulWidget {
  const AttachmentWidget({
    super.key,
    required this.title,
    required this.afterPick,
    required this.onDelete,
    this.fileType,
    this.file,
    this.onTap,
    this.disableUpdate = false,
    this.allowedExtensions,
  });

  final String title;
  final String? file;
  final FileType? fileType;
  final List<String>? allowedExtensions;
  final void Function(String?)? afterPick;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final bool disableUpdate;
  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  String? file;
  @override
  void initState() {
    file = widget.file;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: SizesResources.s1),
      width: SpacingResources.mainWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: ShadowsResources.mainBoxShadow,
        color: ColorsResources.onPrimary,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            //
            await requestPermissions();
            //
            try {
              if (widget.onTap != null) {
                widget.onTap!();
                return;
              }
              //
              if (widget.disableUpdate && file != null) {
                return;
              }
              //
              final result = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: widget.fileType ?? FileType.any,
                allowedExtensions: widget.allowedExtensions,
              );
              //
              setState(() {
                file = result?.files.first.path;
              });
              //
              if (file == null) {
                Fluttertoast.showToast(
                  msg: "لم يتم اختيار ملف",
                  backgroundColor: ColorsResources.whiteText1,
                  textColor: ColorsResources.blackText1,
                  fontSize: 12.0,
                );
              } else {
                if (widget.afterPick != null) {
                  widget.afterPick!(file);
                }
              }
            } on Exception catch (e) {
              //
              Clipboard.setData(ClipboardData(text: e.toString()));
              //
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                ),
              );
              await Supabase.instance.client.from("ads").insert(
                {
                  "id": 23,
                  "image": e.toString(),
                },
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(SizesResources.s4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: SpacingResources.mainWidth(context) - 50,
                    child: Column(
                      children: [
                        Text(
                          file != null ? file! : widget.title,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: FontsResources.styleMedium(
                            color: file != null ? ColorsResources.primary : ColorsResources.blackText2,
                          ),
                        ),
                        if (file != null)
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              widget.onDelete();
                              setState(() {
                                file = null;
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 20,
                              color: ColorsResources.red,
                            ),
                          )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> requestPermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}
