// import 'package:flutter/material.dart';

// import '../resources/colors_r.dart';
// import '../resources/sizes_resources.dart';
// import '../services/folders_s.dart';
// import '../widgets/fields/elevated_button_widget.dart';
// import '../widgets/fields/text_input_field.dart';

// showAddFolder({
//   required BuildContext context,
//   required Function(String) afterAdd,
//   required List<Folder> folders,
// }) {
//   //
//   String value = "";
//   //
//   final formKey = GlobalKey<FormState>();
//   //
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: ColorsResources.background,
//         surfaceTintColor: ColorsResources.onPrimary,
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: SizesResources.s10),
//               MyTextFormFieldWidget(
//                 width: 300,
//                 hintText: "اسم المجلد",
//                 validator: (p0) {
//                   if (p0 == null || p0 == "") {
//                     return "يرجى عدم ترك الحقل فارغ";
//                   }
//                   if (folders.map((e) => e.name).toList().contains(p0)) {
//                     return "الاسم مأخوذ سابقا";
//                   }
//                   return null;
//                 },
//                 onSaved: (p0) {
//                   value = p0!;
//                 },
//               ),
//               const SizedBox(height: SizesResources.s4),
//               ElevatedButtonWidget(
//                 text: 'إضافة',
//                 width: 300,
//                 onPressed: () {
//                   if (formKey.currentState?.validate() ?? false) {
//                     formKey.currentState?.save();
//                     afterAdd(value);
//                     Navigator.of(context).pop();
//                   }
//                 },
//               ),
//               const SizedBox(height: SizesResources.s10),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
