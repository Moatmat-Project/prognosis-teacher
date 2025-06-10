import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';

import 'outer_test_form.dart';
import 'outer_test_information.dart';

class OuterTest {
  ///
  final int id;


  ///
  final OuterTestInformation information;

  ///
  final List<OuterTestForm> forms;

  ///
  OuterTest({
    required this.id,
    required this.information,
    required this.forms,
  });

  PaperSettings toPaperSettings({required List<int?> selections}) {
    return PaperSettings(
      title: information.title,
      date: information.date,
      type: information.paperType,
      selections: selections,
      answers: List.generate(
        forms.length,
        (index) {
          return forms[index].questions.map((e) => e.trueAnswer).toList();
        },
      ),
      formsCount: forms.length,
    );
  }

  OuterTest copyWith({
    int? id,
    OuterTestInformation? information,
    List<OuterTestForm>? forms,
  }) {
    return OuterTest(
      id: id ?? this.id,
      information: information ?? this.information,
      forms: forms ?? this.forms,
    );
  }
}
