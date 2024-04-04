
import 'bank_q.dart';

class Bank {
  //
  final int id;
  final int cost;
  //
  final String clas;
  final String title;
  final String material;
  final String teacher;
  //
  final List<BankQuestion> questions;
  //
  Bank({
    required this.id,
    required this.cost,
    required this.title,
    required this.clas,
    required this.material,
    required this.teacher,
    required this.questions,
  });
  //
  Bank copyWith({
    int? id,
    int? cost,
    String? clas,
    String? title,
    String? material,
    String? teacher,
    List<BankQuestion>? questions,
  }) {
    return Bank(
      id: id ?? this.id,
      cost: cost ?? this.cost,
      title: title ?? this.title,
      clas: clas ?? this.clas,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      questions: questions ?? this.questions,
    );
  }


}
