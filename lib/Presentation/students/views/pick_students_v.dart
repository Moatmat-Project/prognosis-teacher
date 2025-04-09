import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Features/students/domain/entities/user_data.dart';
import '../state/my_students/my_students_cubit.dart';
import 'my_students_v.dart';

class PickStudentsView extends StatefulWidget {
  const PickStudentsView({super.key, required this.onPick});
  final void Function(UserData user) onPick;
  @override
  State<PickStudentsView> createState() => _PickStudentsViewState();
}

class _PickStudentsViewState extends State<PickStudentsView> {
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
      body: BlocBuilder<MyStudentsCubit, MyStudentsState>(
        builder: (context, state) {
          if (state is MyStudentsInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("اضافة حضور الطلاب"),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<MyStudentsCubit>().update();
                },
                child: Column(
                  children: [
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
                                onTap: () {
                                  Fluttertoast.showToast(msg: "تم اضافة حضور الطالب");
                                  widget.onPick(state.users[index]);
                                },
                                userData: state.users[index],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MyStudentsError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("اختيار طالب"),
              ),
              body: Center(
                child: Text(state.error),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("اختيار طالب"),
            ),
            body: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}
