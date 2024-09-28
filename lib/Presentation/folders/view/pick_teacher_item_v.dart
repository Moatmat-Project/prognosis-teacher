import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Presentation/folders/state/pick_teacher_item/pick_teacher_item_cubit.dart';
import 'package:moatmat_teacher/Presentation/folders/view/sub_folders_v.dart';

import '../../../Core/services/folders_system_s.dart';
import '../../../Features/auth/domain/entites/teacher_data.dart';
import '../../../Features/banks/domain/entities/bank.dart';
import '../../../Features/tests/domain/entities/test/test.dart';

class PickTeacherItemView extends StatefulWidget {
  const PickTeacherItemView({
    super.key,
    required this.isTest,
    required this.teacherEmail,
    this.onPickTest,
    this.onPickBank,
  });
  final bool isTest;
  final String teacherEmail;
  final void Function(Test)? onPickTest;
  final void Function(Bank)? onPickBank;
  @override
  State<PickTeacherItemView> createState() => _PickTeacherItemViewState();
}

class _PickTeacherItemViewState extends State<PickTeacherItemView> {
  ///
  bool isLoading = true;

  ///
  late final FoldersSystemService foldersSystemService;

  ///
  late TeacherData teacherData;

  ///
  @override
  void initState() {
    context.read<PickTeacherItemCubit>().init(
          teacher: widget.teacherEmail,
          isTest: widget.isTest,
        );
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PickTeacherItemCubit, PickTeacherItemState>(
        builder: (context, state) {
          final cubit = context.read<PickTeacherItemCubit>();
          return SubFoldersView(
            //
            allFolders: cubit.listAllDirectories,
            //
            isLoading: state.isLoading,
            //
            folders: state.folders,
            //
            tests: state.tests,
            //
            banks: state.banks,
            //
            name: state.teacher ?? "",
            //
            onPick: (directory) => cubit.exploreFolder(directory),
            //
            openDirectory: (directory) => cubit.exploreFolder(directory),
            //
            onPop: state.canPop ? () => cubit.backDirectory() : null,
            //
            openAll: null,
            //
            onPickBank: widget.onPickBank,
            //
            onPickTest: widget.onPickTest,
            //
          );
        },
      ),
    );
  }
}
