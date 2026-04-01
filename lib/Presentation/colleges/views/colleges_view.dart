// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:moatmat_teacher/Core/functions/show_alert.dart';
// import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
// import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
// import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';
// import 'package:moatmat_teacher/Presentation/colleges/state/college_bloc/college_bloc.dart';
// import 'package:moatmat_teacher/Presentation/colleges/widgets/college_card_widget.dart';
// import '../widgets/add_college_fab_widget.dart';
// import './add_or_update_college_view.dart';

// class CollegesView extends StatefulWidget {
//   final int schoolId;

//   const CollegesView({super.key, required this.schoolId});

//   @override
//   State<CollegesView> createState() => _CollegesViewState();
// }

// class _CollegesViewState extends State<CollegesView> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     // Always fetch colleges for the provided school
//     context.read<CollegeBloc>().add(FetchCollegesBySchoolId(widget.schoolId));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الكُليات'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(SpacingResources.sidePadding),
//         child: Column(
//           children: [
//             // Search Bar
//             MyTextFormFieldWidget(
//               controller: _searchController,
//               hintText: 'بحث عن كُلية...',
//               textAlign: TextAlign.right,
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value?.toLowerCase() ?? '';
//                 });
//               },
//               suffix: const Icon(Icons.search),
//             ),
//             const SizedBox(height: 16),
//             // Colleges Grid
//             Expanded(child: _buildCollegesView()),
//           ],
//         ),
//       ),
//       floatingActionButton: AddCollegeFabWidget(
//         schoolId: widget.schoolId,
//         onPressed: _navigateToAddCollege,
//       ),
//     );
//   }

//   Widget _buildCollegesView() {
//     return BlocConsumer<CollegeBloc, CollegeState>(
//       listener: (context, state) {
//         if (state is CollegeError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         } else if (state is CollegeActionSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );

//           // Refresh colleges after action
//           context.read<CollegeBloc>().add(FetchCollegesBySchoolId(widget.schoolId));
//         }
//       },
//       builder: (context, state) {
//         if (state is CollegeLoading) {
//           return const Center(
//             child: CupertinoActivityIndicator(),
//           );
//         } else if (state is CollegeLoaded) {
//           // Filter colleges based on search query
//           final filteredColleges = state.colleges.where((college) {
//             return college.name?.toLowerCase().contains(_searchQuery) ?? false;
//           }).toList();

//           if (filteredColleges.isEmpty) {
//             return Center(
//               child: Text(_searchQuery.isEmpty ? 'لا يوجد كليات' : 'لا توجد نتائج بحث'),
//             );
//           }
//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16.0,
//               mainAxisSpacing: 16.0,
//               childAspectRatio: 0.8,
//             ),
//             itemCount: filteredColleges.length,
//             itemBuilder: (context, index) {
//               final college = filteredColleges[index];
//               return CollegeCardWidget(
//                 college: college,
//                 onEdit: () => _navigateToEditCollege(college),
//                 onDelete: () => _showDeleteDialog(college),
//               );
//             },
//           );
//         } else if (state is CollegeError) {
//           return Center(
//             child: Text('خطأ: ${state.message}'),
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }

//   void _navigateToAddCollege() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AddOrUpdateCollegeView(
//           schoolId: widget.schoolId,
//         ),
//       ),
//     );
//   }

//   void _navigateToEditCollege(College college) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AddOrUpdateCollegeView(
//           college: college,
//           schoolId: widget.schoolId,
//         ),
//       ),
//     );
//   }

//   void _showDeleteDialog(College college) {
//     showAlert(
//       context: context,

//       title: 'حذف كُلية',
//       body: 'هل انت متاكد انك تريد حذف كُلية "${college.name}"?',
//       onAgree: () {
//         context.read<CollegeBloc>().add(DeleteCollegeEvent(college.id));
//       },
//       agreeBtn: 'حذف',
//     );
//   }
// }
