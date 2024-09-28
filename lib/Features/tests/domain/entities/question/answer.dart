class Answer {
  final int id;
  final String? text;
  final List<String>? equations;
  final bool? trueAnswer;
  final String? image;

  Answer({
    required this.id,
    required this.text,
    required this.equations,
    required this.trueAnswer,
    required this.image,
  });

  Answer copyWith({
    int? id,
    String? text,
    List<String>? equations,
    bool? trueAnswer,
    String? image,
  }) {
    return Answer(
      id: id ?? this.id,
      text: text ?? this.text,
      equations: equations ?? this.equations,
      trueAnswer: trueAnswer ?? this.trueAnswer,
      image: image ?? this.image,
    );
  }

  bool isNotEmpty() {
    bool con1 = text != null && text != "";
    bool con2 = image != null && image != "";
    return con1 || con2;
  }
}
