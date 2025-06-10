import 'package:moatmat_teacher/Features/tests/domain/entities/question/answer.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';

class OuterQuestion {
  final int id;
  final int trueAnswer;

  OuterQuestion({
    required this.id,
    required this.trueAnswer,
  });
  OuterQuestion copyWith({
    int? id,
    int? trueAnswer,
  }) {
    return OuterQuestion(
      id: id ?? this.id,
      trueAnswer: trueAnswer ?? this.trueAnswer,
    );
  }

  Question toQuestion() {
    return Question(
      id: id,
      lowerImageText: "السؤال رقم : ${id + 1}",
      upperImageText: "",
      image: "",
      video: "",
      explain: "",
      period: null,
      editable: null,
      equations: [],
      colors: [],
      explainImage: null,
      //
      answers: List.generate(
        5,
        (index) {
          return Answer(
            id: 0,
            text: "",
            equations: [],
            trueAnswer: trueAnswer == index,
            image: "",
          );
        },
      ),
    );
  }
}
