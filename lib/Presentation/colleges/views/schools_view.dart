// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
// import 'package:moatmat_admin/Presentation/schools/state/school_bloc/school_bloc.dart';
// import 'package:moatmat_admin/Presentation/schools/widgets/school_card_widget.dart';
// import 'colleges_view.dart';

// class SchoolsCollegeView extends StatefulWidget {
//   const SchoolsCollegeView({super.key});

//   @override
//   State<SchoolsCollegeView> createState() => _SchoolsCollegeViewState();
// }

// class _SchoolsCollegeViewState extends State<SchoolsCollegeView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<SchoolBloc>().add(FetchSchools());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('اختر الجامعة'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(SpacingResources.sidePadding),
//         child: BlocBuilder<SchoolBloc, SchoolState>(
//           builder: (context, state) {
//             if (state is SchoolLoading) {
//               return const Center(child: CupertinoActivityIndicator());
//             } else if (state is SchoolLoaded) {
//               if (state.schools.isEmpty) {
//                 return const Center(child: Text('لا توجد جامعات'));
//               }
//               return ListView.builder(
//                 itemCount: state.schools.length,
//                 itemBuilder: (context, index) {
//                   final school = state.schools[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: SchoolCardWidget(
//                       school: school,
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => CollegesView(schoolId: school.id),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//             } else if (state is SchoolError) {
//               return Center(child: Text('خطأ: ${state.message}'));
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }
