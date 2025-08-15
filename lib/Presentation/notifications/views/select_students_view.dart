import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/functions/show_alert.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/text_input_field.dart';
import 'package:moatmat_teacher/Presentation/students/state/my_students/my_students_cubit.dart';

class SelectStudentsView extends StatefulWidget {
  const SelectStudentsView({super.key});

  @override
  State<SelectStudentsView> createState() => _SelectStudentsViewState();
}

class _SelectStudentsViewState extends State<SelectStudentsView> {
  late final TextEditingController _searchController;
  final Set<String> selectedUserIds = {};

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      context.read<MyStudentsCubit>().search(_searchController.text);
    });
    context.read<MyStudentsCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختر الطلاب"),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + SizesResources.s2),
        child: AnimatedCrossFade(
          secondChild: SizedBox(),
          firstChild: _CustomBottomWidget(selectedUserIds: selectedUserIds),
          crossFadeState: selectedUserIds.isEmpty ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ),
      body: BlocBuilder<MyStudentsCubit, MyStudentsState>(
        builder: (context, state) {
          if (state is MyStudentsInitial) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (selectedUserIds.isNotEmpty) {
                  showAlert(
                    context: context,
                    title: "تأكيد الخروج",
                    body: "هل أنت متأكد من الخروج؟",
                    onAgree: () {
                      Navigator.pop(context);
                    },
                  );
                  return;
                }
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextFormFieldWidget(
                      hintText: "بحث",
                      suffix: const Icon(Icons.search),
                      controller: _searchController,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        final isSelected = selectedUserIds.contains(user.uuid);
                        return ListTile(
                          leading: Checkbox(
                            value: isSelected,
                            onChanged: (_) {
                              setState(() {
                                isSelected ? selectedUserIds.remove(user.uuid) : selectedUserIds.add(user.uuid);
                              });
                            },
                          ),
                          title: Text(user.name),
                          onTap: () {
                            setState(() {
                              isSelected ? selectedUserIds.remove(user.uuid) : selectedUserIds.add(user.uuid);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}

class _CustomBottomWidget extends StatelessWidget {
  final Set<String> selectedUserIds;
  const _CustomBottomWidget({required this.selectedUserIds});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsResources.primary,
        ),
        onPressed: () {
          Navigator.of(context).pop(selectedUserIds.toList());
        },
        child: const Text("تأكيد", style: TextStyle(color: ColorsResources.whiteText1)),
      ),
    );
  }
}
