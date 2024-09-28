import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/fonts_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/services/folders_s.dart';
import 'package:moatmat_teacher/Core/services/folders_system_s.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';

import '../../../Features/auth/domain/entites/teacher_data.dart';
import '../../../Presentation/folders/state/folders_manager/folders_manager_cubit.dart';
import '../../injection/app_inj.dart';

addItemToFolder({
  required BuildContext context,
  required int id,
  required bool isTest,
}) {
  showDialog(
    context: context,
    builder: (context) => AddItemToFolderDialog(
      id: id,
      isTest: isTest,
    ),
  );
}

class AddItemToFolderDialog extends StatefulWidget {
  const AddItemToFolderDialog({
    super.key,
    required this.id,
    required this.isTest,
  });
  final int id;
  final bool isTest;
  @override
  State<AddItemToFolderDialog> createState() => _AddItemToFolderDialogState();
}

class _AddItemToFolderDialogState extends State<AddItemToFolderDialog> {
  //
  String currentPath = "home";
  //
  late final FoldersSystemService foldersSystemService;
  //
  int? selectedSubFolder;
  //
  List<String> folders = [];
  //
  @override
  void initState() {
    initFolders();
    super.initState();
  }

  //
  initFolders() async {
    //
    if (widget.isTest) {
      foldersSystemService = FoldersSystemService(
        onUpdate: (directories) {
          locator<TeacherData>().updateTestsFolders(deepCopy(directories));
        },
        directories: deepCopy(locator<TeacherData>().testsFolders),
      );
    } else {
      foldersSystemService = FoldersSystemService(
        onUpdate: (directories) {
          locator<TeacherData>().updateBanksFolders(deepCopy(directories));
        },
        directories: deepCopy(locator<TeacherData>().banksFolders),
      );
    }
    //
    folders = foldersSystemService.getSubdirectories();
    //
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizesResources.s5,
          vertical: SizesResources.s5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //
            const SizedBox(height: SizesResources.s2),
            //
            PickFolderWidget(
              folders: folders,
              onTap: (directory) {
                setState(() {
                  //
                  foldersSystemService.pushPathForward(directory: directory);
                  //
                  folders = foldersSystemService.getSubdirectories();
                });
              },
            ),
            const SizedBox(height: SizesResources.s2),
            ElevatedButtonWidget(
              text: foldersSystemService.canPop ? "حفظ في ${foldersSystemService.path.split("/").last}" : "حفظ هنا",
              onPressed: () {
                foldersSystemService.addItemDirectory(item: widget.id);
                //
                context.read<FoldersManagerCubit>().init(widget.isTest);
                //
                Navigator.of(context).pop();
              },
              width: SpacingResources.mainHalfWidth(context),
            ),
            const SizedBox(height: SizesResources.s2),
            //

            //
          ],
        ),
      ),
    );
  }
}

class PickFolderWidget extends StatelessWidget {
  const PickFolderWidget({
    super.key,
    required this.folders,
    required this.onTap,
  });
  final List<String> folders;
  final Function(String index) onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Row(
            children: [
              Text("اضافة الى مجلد"),
            ],
          ),
          //
          const SizedBox(height: SizesResources.s2),
          Expanded(
            child: folders.isEmpty
                ? const Center(
                    child: Text(
                      "لا يوجد مجلدات \n قم بانشاء مجلدات لاضافة العناصر اليها",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      return FolderSelectableTileWidget(
                        title: folders[index],
                        onTap: () {
                          onTap(folders[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FolderSelectableTileWidget extends StatelessWidget {
  const FolderSelectableTileWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.selected = false,
  });
  final String title;
  final VoidCallback onTap;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainHalfWidth(context),
      height: 50,
      margin: const EdgeInsets.symmetric(
        vertical: SizesResources.s1,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        borderRadius: BorderRadius.circular(10),
        border: selected ? Border.all(color: ColorsResources.darkPrimary) : null,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SizesResources.s2,
              vertical: SizesResources.s2,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: FontsResources.styleBold(size: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
