import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Presentation/students/state/cubit/explore_class_students_cubit.dart';
import 'package:moatmat_teacher/Presentation/students/views/my_students_v.dart';

class ExploreClassStudentsView extends StatefulWidget {
  const ExploreClassStudentsView({
    super.key,
    required this.classs,
  });
  final String classs;
  @override
  State<ExploreClassStudentsView> createState() =>
      _ExploreClassStudentsViewState();
}

class _ExploreClassStudentsViewState extends State<ExploreClassStudentsView> {
  @override
  void initState() {
    context.read<ExploreClassStudentsCubit>().init(classs: widget.classs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("طلاب ${widget.classs}"),
      ),
      body: BlocBuilder<ExploreClassStudentsCubit, ExploreClassStudentsState>(
        builder: (context, state) {
          if (state is ExploreClassStudentsInitial) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return StudentTileWidget(userData: state.users[index]);
              },
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
