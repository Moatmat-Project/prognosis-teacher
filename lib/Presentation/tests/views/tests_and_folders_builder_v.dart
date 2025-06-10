import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Presentation/scanner/state/cubit/explore_outer_tests_cubit.dart';

import '../state/my_tests/my_tests_cubit.dart';
import '../widgets/test_tile_w.dart';
import 'add_test_vew.dart';

class TestsAndFoldersViewBuilder extends StatelessWidget {
  const TestsAndFoldersViewBuilder({
    super.key,
    required this.tests,
    required this.folders,
    required this.onOpenTest,
    required this.onOpenFolder,
    required this.onBack,
    required this.onDeleteFolder,
    required this.onUpdateFolder,
  });
  final List<Test> tests;
  final List<String> folders;
  //
  final Function(int i, Test t) onOpenTest;
  final Function(int i, String f) onOpenFolder;
  final Function(int i, String f) onDeleteFolder;
  final Function(int i, String f) onUpdateFolder;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: tests.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TestTileWidget(
                test: tests[index],
                onPick: () {
                  onOpenTest(index, tests[index]);
                },
              ),
            ],
          );
        },
      ),
     
    );
  }
}
