import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/answer.dart';
import 'package:moatmat_teacher/Presentation/questions/view/create_answer_v.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/answer_item_widget.dart';
import 'package:moatmat_teacher/Presentation/questions/widgets/question_item_widget.dart';
import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/elevated_button_widget.dart';
import '../state/cubit/create_question_cubit.dart';

class SetUpAnswerView extends StatefulWidget {
  const SetUpAnswerView(
      {super.key, required this.answers, required this.onFinish});
  final List<Answer> answers;
  final VoidCallback onFinish;
  @override
  State<SetUpAnswerView> createState() => _SetUpAnswerViewState();
}

class _SetUpAnswerViewState extends State<SetUpAnswerView> {
  List<Answer> answers = [];
  @override
  void initState() {
    answers = widget.answers;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SetUpAnswerView oldWidget) {
    setState(() {
      answers = widget.answers;
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //
    final bloc = context.read<CreateQuestionCubit>();
    //
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("اعداد اجابات السؤال"),
        actions: [
          IconButton(
            onPressed: () {
              bloc.emitSetUpQuestion();
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.answers.length,
        itemBuilder: (context, index) {
          return AnswerItemWidget(
            answer: widget.answers[index],
            onTap: () {
              final page = MaterialPageRoute(
                builder: (context) => CreateAnswerView(
                  answer: widget.answers[index],
                  result: (a) {
                    bloc.updateAnswer(index, a);
                  },
                ),
              );
              Navigator.of(context).push(page).then((value) => setState(() {}));
            },
            onDelete: () {
              bloc.removeAnswer(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorsResources.primary,
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => CreateAnswerView(
                    result: (a) {
                      bloc.addAnswer(a);
                    },
                  ),
                ),
              )
              .then((value) => setState(() {}));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "حفظ السؤال",
          onPressed: answers.length >= 2
              ? () async {
                  widget.onFinish();
                }
              : null,
        ),
      ),
    );
  }
}
