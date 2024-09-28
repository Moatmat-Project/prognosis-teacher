import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Presentation/scanner/views/set_outer_test_answers_v.dart';
import 'package:moatmat_teacher/Presentation/scanner/views/set_outer_test_informations.dart';
import 'package:moatmat_teacher/Presentation/tests/state/add_test/add_test_cubit.dart';
import '../../../Core/widgets/view/upload_done_v.dart';
import '../state/add_outer_test/add_outer_test_cubit.dart';

class AddOuterTestView extends StatefulWidget {
  const AddOuterTestView({super.key, this.test});
  final OuterTest? test;
  @override
  State<AddOuterTestView> createState() => _AddOuterTestViewState();
}

class _AddOuterTestViewState extends State<AddOuterTestView> {
  @override
  void initState() {
    context.read<AddOuterTestCubit>().init(test: widget.test);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AddOuterTestCubit, AddOuterTestState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AddOuterTestInformation) {
          return SetOuterTestInformationView(
            information: state.information,
            forms: state.forms,
          );
        } else if (state is AddOuterTestViewForms) {
          return SetOuterTestAnswersView(
            forms: state.forms,
            onSetForms: (forms) {
              context.read<AddOuterTestCubit>().setForms(forms);
            },
          );
        } else if (state is AddOuterTestDone) {
          return UploadingDone(
            onTapButton: () {
              Navigator.of(context).pop();
            },
          );
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    ));
  }
}
