import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Presentation/folders/state/folders_manager/folders_manager_cubit.dart';
import 'package:moatmat_teacher/Presentation/folders/view/sub_folders_v.dart';

class FoldersViewManager extends StatefulWidget {
  const FoldersViewManager({
    super.key,
    required this.isTest,
    required this.title,
    required this.openAll,
  });

  final String title;
  final bool isTest;
  final void Function()? openAll;
  @override
  State<FoldersViewManager> createState() => _FoldersViewManagerState();
}

class _FoldersViewManagerState extends State<FoldersViewManager> {
  @override
  void initState() {
    context.read<FoldersManagerCubit>().init(widget.isTest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FoldersManagerCubit, FoldersManagerState>(
        builder: (context, state) {
          final cubit = context.read<FoldersManagerCubit>();
          return SubFoldersView(
            //
            allFolders: cubit.listAllDirectories,
            //
            onPick: (directory) => cubit.exploreFolder(directory),
            //
            folders: state.folders,
            //
            isLoading: state.isLoading,
            //
            tests: state.tests,
            //
            banks: state.banks,
            //
            name: widget.title,
            //
            openDirectory: (index) => cubit.exploreFolder(index),
            //
            addDirectory: (folder) => cubit.createDirectory(folder),
            //
            deleteDirectory: (folder) => cubit.deleteDirectory(folder),
            //
            onPop: state.canPop ? () => cubit.popBack() : null,
            //
            deleteBank: (id) => cubit.removeItem(id),
            //
            deleteTest: (id) => cubit.removeItem(id),
            //
            openAll: widget.openAll,
          );
        },
      ),
    );
  }
}
