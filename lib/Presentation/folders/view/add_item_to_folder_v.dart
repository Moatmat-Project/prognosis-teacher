import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Presentation/folders/state/add_to_folder/add_to_folder_cubit.dart';
import 'package:moatmat_teacher/Presentation/folders/view/folders_views_manager.dart';
import 'package:moatmat_teacher/Presentation/folders/view/sub_folders_v.dart';

import '../../../Core/services/folders_system_s.dart';
import '../../../Features/tests/domain/entities/test/test.dart';

class AddItemToFolderView extends StatefulWidget {
  const AddItemToFolderView({
    super.key,
    required this.id,
    required this.isTest,
    required this.teacherEmail,
  });
  final int id;
  final bool isTest;
  final String teacherEmail;

  @override
  State<AddItemToFolderView> createState() => _AddItemToFolderViewState();
}

class _AddItemToFolderViewState extends State<AddItemToFolderView> {
  ///
  bool isLoading = true;

  ///
  late final FoldersSystemService foldersSystemService;

  ///
  late TeacherData teacherData;

  ///
  @override
  void initState() {
    context.read<AddToFolderCubit>().init(
          item: widget.id,
          teacher: widget.teacherEmail,
          isTest: widget.isTest,
        );
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AddToFolderCubit, AddToFolderState>(
        builder: (context, state) {
          final cubit = context.read<AddToFolderCubit>();
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
            onPickBank: (b) {},
            //
            onPickTest: (t) {},

            //
            onSave: () {
              cubit.addToDirectory(widget.id);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
