import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Presentation/questions/view/set_up_answers_v.dart';
import 'package:moatmat_teacher/Presentation/questions/view/set_up_question_v.dart';

import '../state/cubit/create_question_cubit.dart';

class AddQuestionView extends StatefulWidget {
  //
  const AddQuestionView({
    super.key,
    required this.result,
    this.question,
    required this.isItBank,
  });
  //
  final Question? question;
  final Function(Question) result;
  final bool isItBank;
  @override
  State<AddQuestionView> createState() => _AddQuestionViewState();
}

class _AddQuestionViewState extends State<AddQuestionView> {
  @override
  void initState() {
    context.read<CreateQuestionCubit>().init(q: widget.question);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CreateQuestionCubit, CreateQuestionState>(
        builder: (context, state) {
          if (state is CreateQuestionInitial) {
            return SetUpQuestionView(
              question: state.question,
            );
          } else if (state is CreateQuestionSetUpAnswers) {
            return SetUpAnswerView(
              answers: state.answers,
              onFinish: () {
                //
                final question = context.read<CreateQuestionCubit>().question;
                //
                widget.result(question);
                //
                Navigator.of(context).pop();
              },
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
