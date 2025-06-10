import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/functions/dialogs/add_sub_folder_d.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/fonts_r.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_folders_v.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/banks/views/bank_details_v.dart';
import 'package:moatmat_teacher/Presentation/banks/widgets/bank_tile_w.dart';
import 'package:moatmat_teacher/Presentation/folders/widgets/folder_item_w.dart';
import 'package:moatmat_teacher/Presentation/tests/widgets/test_tile_w.dart';

import '../../../Core/resources/colors_r.dart';
import '../../tests/views/test_details_v.dart';

class SubFoldersView extends StatelessWidget {
  const SubFoldersView({
    super.key,
    required this.openDirectory,
    this.addDirectory,
    this.deleteDirectory,
    this.onPop,
    this.onSave,
    this.deleteTest,
    this.deleteBank,
    required this.name,
    required this.openAll,
    required this.folders,
    required this.tests,
    required this.banks,
    required this.isLoading,
    required this.onPick,
    this.allFolders,
    this.onPickTest,
    this.onPickBank,
  });
  //
  final List<String> folders;
  //
  final List<String> Function()? allFolders;
  //
  final List<Test> tests;
  //
  final List<Bank> banks;
  //
  final bool isLoading;
  //
  final String name;
  //
  final VoidCallback? openAll;
  //
  final void Function(String) openDirectory;
  //
  final void Function(String)? addDirectory;
  //
  final void Function(String)? deleteDirectory;
  //
  //
  final void Function(int)? deleteTest;
  //
  final void Function(int)? deleteBank;
  //
  final void Function()? onPop;
  final VoidCallback? onSave;
  //
  final void Function(String) onPick;
  //
  final void Function(Test)? onPickTest;
  final void Function(Bank)? onPickBank;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            "مجلدات $name",
            style: FontsResources.styleMedium(
              size: 16,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          if (allFolders != null)
            IconButton(
              onPressed: () {
                //
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchInFoldersView(
                      folders: allFolders!(),
                      onPick: onPick,
                    ),
                  ),
                );
                //
              },
              icon: const Icon(Icons.search),
            ),
        ],
      ),
      body: Column(
        children: [
          if (openAll != null)
            TouchableTileWidget(
              title: "تصفح كامل $name",
              onTap: openAll,
              iconData: Icons.arrow_forward_ios,
            ),
          //
          if (onPop != null)
            Row(
              children: [
                IconButton(
                  onPressed: onPop,
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 15,
                  ),
                ),
              ],
            ),
          //
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: getItemLength(),
                    itemBuilder: (context, index) {
                      return getWidgetByIndex(context, index);
                    },
                  ),
                ),
        ],
      ),
      bottomNavigationBar: onSave != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButtonWidget(
                    text: "حفظ هنا",
                    onPressed: onSave,
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: addDirectory != null
          ? FloatingActionButton(
              backgroundColor: ColorsResources.primary,
              foregroundColor: ColorsResources.whiteText1,
              onPressed: () {
                addSubFolderFunction(
                  context: context,
                  onAdd: (f) {
                    addDirectory!(f);
                  },
                );
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
    );
  }

  int getItemLength() {
    int length = 0;
    length += folders.length;
    length += tests.length;
    length += banks.length;
    return length;
  }

  Widget getWidgetByIndex(BuildContext context, int index) {
    //
    int fLength = folders.length;
    int tLength = tests.length;
    //
    if (index < fLength) {
      return InkWell(
        onLongPress: deleteDirectory != null
            ? () {
                showAlert(
                  context: context,
                  title: "تاكيد الحذف",
                  body: "هل انت متاكد من رغبتك بحذف هذا المجلد؟",
                  onAgree: () {
                    deleteDirectory!(folders[index]);
                  },
                );
              }
            : null,
        child: FolderItemWidget(
          folder: folders[index],
          onTap: () {
            openDirectory(folders[index]);
          },
        ),
      );
    } else if (index < fLength + tLength) {
      return InkWell(
        onLongPress: deleteTest != null
            ? () {
                showAlert(
                  context: context,
                  title: "تاكيد الحذف",
                  body: "هل انت متاكد من رغبتك بازاله هذا الاختبار؟",
                  onAgree: () {
                    deleteTest!(tests[index - fLength].id);
                  },
                );
              }
            : null,
        child: TestTileWidget(
          test: tests[index - fLength],
          isFolderItem: true,
          onPick: () async {
            if (onPickTest != null) {
              onPickTest!(tests[index - fLength]);
            } else {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TestDetailsView(
                    test: tests[index - fLength],
                  ),
                ),
              );
            }
          },
        ),
      );
      //
    } else {
      return InkWell(
        onLongPress: deleteBank != null
            ? () {
                showAlert(
                  context: context,
                  title: "تاكيد الحذف",
                  body: "هل انت متاكد من رغبتك بازاله هذا البنك؟",
                  onAgree: () {
                    deleteBank!(banks[index - (tLength + fLength)].id);
                  },
                );
              }
            : null,
        child: BankTileWidget(
          bank: banks[index - (tLength + fLength)],
          isFolderItem: true,
          onPick: () async {
            if (onPickBank != null) {
              onPickBank!(banks[index - fLength]);
            } else {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BankDetailsView(
                    bank: banks[index - fLength],
                  ),
                ),
              );
            }
          },
        ),
      );
    }
  }
}
