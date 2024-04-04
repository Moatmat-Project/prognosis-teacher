class TestAnswer {
  //
  final String? answer;
  final String? equation;
  final bool isCorrect;
  TestAnswer({
    required this.answer,
    required this.equation,
    required this.isCorrect,
  });
  TestAnswer copyWith({
    String? answer,
    String? equation,
    bool? isCorrect,
  }) {
    return TestAnswer(
      answer: answer ?? this.answer,
      equation: equation ?? this.equation,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
