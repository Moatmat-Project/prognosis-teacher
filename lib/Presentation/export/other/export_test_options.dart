import 'package:equatable/equatable.dart';

import '../../../Features/tests/domain/entities/question/question.dart';
import 'print_type.dart';

class ExportTestOptions extends Equatable {
  //
  int formsCount;
  //
  int? minutes;
  //
  String email;
  //
  String? waterMark;
  //
  PrintType printType;
  //
  final List<Question> questions;
  //
  List<List<int>>? specialOrder;

  ExportTestOptions({
    required this.formsCount,
    required this.minutes,
    required this.email,
    required this.waterMark,
    required this.printType,
    required this.specialOrder,
    required this.questions,
  });

  @override
  List<Object?> get props => [
        formsCount,
        minutes,
        email,
        printType,
        specialOrder,
        questions,
      ];
}
