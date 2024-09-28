import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/students/views/student_v.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/services/classification_s.dart';
import '../../../Features/students/domain/entities/user_data.dart';
import '../state/my_students/my_students_cubit.dart';

class MyStudentsView extends StatefulWidget {
  const MyStudentsView({super.key});
  @override
  State<MyStudentsView> createState() => _MyStudentsViewState();
}

class _MyStudentsViewState extends State<MyStudentsView> {
  //
  late final TextEditingController _controller;
  @override
  void initState() {
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      context.read<MyStudentsCubit>().search(_controller.text);
      setState(() {});
    });
    //
    context.read<MyStudentsCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلابي"),
      ),
      body: BlocBuilder<MyStudentsCubit, MyStudentsState>(
        builder: (context, state) {
          if (state is MyStudentsInitial) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MyStudentsCubit>().update();
              },
              child: Column(
                children: [
                  const SizedBox(height: SizesResources.s2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: SpacingResources.mainWidth(context),
                        child: Text(
                          "العدد الكلي : ${state.users.length}",
                          style: const TextStyle(
                            color: ColorsResources.blackText2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizesResources.s2),
                  MyTextFormFieldWidget(
                    hintText: "بحث",
                    suffix: const Icon(Icons.search),
                    controller: _controller,
                  ),
                  const SizedBox(height: SizesResources.s2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            StudentTileWidget(
                              userData: state.users[index],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is MyStudentsError) {
            return Center(
              child: Text(state.error),
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

class StudentTileWidget extends StatefulWidget {
  const StudentTileWidget({
    super.key,
    required this.userData,
    this.onLongPress,
  });
  final UserData userData;
  final Function()? onLongPress;

  @override
  State<StudentTileWidget> createState() => _StudentTileWidgetState();
}

class _StudentTileWidgetState extends State<StudentTileWidget> {
  late String classs;
  @override
  void initState() {
    classs = ClassificationService().getById(widget.userData.uuid)?.classs ??
        widget.userData.classroom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: SpacingResources.mainWidth(context),
          margin: const EdgeInsets.symmetric(
            vertical: SizesResources.s1,
          ),
          decoration: BoxDecoration(
            color: ColorsResources.onPrimary,
            boxShadow: ShadowsResources.mainBoxShadow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onLongPress: widget.onLongPress,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StudentView(
                      userId: widget.userData.uuid,
                      userName: widget.userData.name.replaceAll(" ", "_"),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SizesResources.s3,
                  horizontal: SizesResources.s3,
                ),
                child: Row(
                  children: [
                    //
                    const Icon(Icons.person, size: 16),
                    //
                    const SizedBox(width: SizesResources.s2),
                    //
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.userData.name),
                            const SizedBox(height: SizesResources.s1),
                            Text(
                              classs,
                              style: const TextStyle(
                                color: ColorsResources.blackText2,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //
                    const Icon(Icons.arrow_forward_ios, size: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
