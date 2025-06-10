// import 'package:flutter/material.dart';
// import 'package:moatmat_teacher/Core/functions/show_add_folder.dart';
// import 'package:moatmat_teacher/Core/functions/show_alert.dart';
// import 'package:moatmat_teacher/Core/services/folders_s.dart';

// import '../../../Core/resources/colors_r.dart';
// import '../../../Core/resources/shadows_r.dart';
// import '../../../Core/resources/sizes_resources.dart';
// import '../../../Core/resources/spacing_resources.dart';

// class FolderWidget extends StatelessWidget {
//   const FolderWidget({
//     super.key,
//     required this.folder,
//     required this.onOpenFolder,
//     required this.onDeleteFolder,
//     required this.onUpdateFolder,
//     this.disableUpdate = false,
//   });
//   final Folder folder;
//   final VoidCallback onOpenFolder;
//   final VoidCallback onDeleteFolder;
//   final void Function(Folder) onUpdateFolder;
//   final bool disableUpdate;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: SpacingResources.mainWidth(context),
//       margin: const EdgeInsets.symmetric(
//         vertical: SizesResources.s1,
//       ),
//       decoration: BoxDecoration(
//         color: ColorsResources.onPrimary,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: ShadowsResources.mainBoxShadow,
//       ),
//       child: Material(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onOpenFolder,
//           onLongPress: () {
//             showAlert(
//               context: context,
//               title: "حذف المجلد",
//               body: "هل انت متاكد من انك تريد حذف الجلد",
//               onAgree: () {
//                 onDeleteFolder();
//               },
//             );
//           },
//           borderRadius: BorderRadius.circular(8),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: SizesResources.s3,
//               horizontal: SizesResources.s3,
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.folder),
//                 const SizedBox(width: SizesResources.s2),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 2),
//                   child: Text(folder.name),
//                 ),
//                 const Spacer(),
//                 Opacity(
//                   opacity: disableUpdate ? 0 : 1,
//                   child: IconButton(
//                     onPressed: () {
//                       if (disableUpdate) return;
//                       showAddFolder(
//                         context: context,
//                         afterAdd: (p0) {
//                           var f = folder.copyWith(name: p0);
//                           onUpdateFolder(f);
//                         },
//                         folders: [folder],
//                       );
//                     },
//                     icon: const Icon(Icons.edit, size: 14),
//                   ),
//                 ),
//                 const Icon(Icons.arrow_forward_ios, size: 12)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
