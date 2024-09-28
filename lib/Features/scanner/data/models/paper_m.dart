import 'dart:typed_data';

import 'package:moatmat_teacher/Features/scanner/data/models/row_bubble_m.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/answers_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/form_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/id_data.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';

class PaperModel extends Paper {
  PaperModel({
    required super.settings,
    required super.data,
  });
  Map<String, dynamic> toJson() => {
        'settings': PaperSettingsModel.fromClass(settings).toJson(),
        'data': PaperDataModel.fromClass(data).toJson(),
      };

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    return PaperModel(
      settings: PaperSettingsModel.fromJson(json['settings']),
      data: PaperDataModel.fromJson(json['data']),
    );
  }
}

class PaperSettingsModel extends PaperSettings {
  PaperSettingsModel({
    required super.title,
    required super.date,
    required super.type,
    required super.selections,
    required super.answers,
    required super.formsCount,
  });
  //
  Map<String, dynamic> toJson() {
    return {
      'date': date.toString(),
      'type': type.name,
      'selections': selections,
      'answers': answers,
    };
  }

  factory PaperSettingsModel.fromJson(Map<String, dynamic> json) {
    return PaperSettingsModel(
      title: json['title'],
      selections: json['selections'],
      answers: json['answers'],
      date: DateTime.parse(json['date']),
      formsCount: json["form_count"],
      type: PaperType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
    );
  }
  factory PaperSettingsModel.fromClass(PaperSettings settings) {
    return PaperSettingsModel(
      title: settings.title,
      date: settings.date,
      type: settings.type,
      selections: settings.selections,
      answers: settings.answers,
      formsCount: settings.formsCount,
    );
  }
}

class PaperDataModel extends PaperData {
  PaperDataModel({
    required super.id,
    required super.answers,
    required super.form,
  });
  //
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answers': answers.rows.map((row) {
        return RowBubblesModel.fromClass(row).toJson();
      }).toList(),
    };
  }

  factory PaperDataModel.fromJson(Map<String, dynamic> json) {
    List idRows = json[''];
    List answersRows = json[''];
    return PaperDataModel(
      id: IdData(
        rows: idRows.map((row) {
          return RowBubblesModel.fromJson(row);
        }).toList(),
      ),
      form: FormData(row: RowBubblesModel.fromJson(json["form"])),
      answers: AnswersData(
        rows: answersRows.map((row) {
          return RowBubblesModel.fromJson(row);
        }).toList(),
      ),
    );
  }
  factory PaperDataModel.fromClass(PaperData data) {
    return PaperDataModel(
      id: data.id,
      answers: data.answers,
      form: data.form,
    );
  }
}
