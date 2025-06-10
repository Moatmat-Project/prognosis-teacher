import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';

import 'attendance_record_model.dart';

class AttendanceSetModel extends AttendanceSet {
  AttendanceSetModel({
    required super.id,
    required super.title,
    required super.teacher,
    required super.date,
  });

  factory AttendanceSetModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSetModel(
      id: json['id'] ?? 0,
      title: json['title'],
      teacher: json['teacher'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson({bool includeId = false, bool includeRecords = false}) {
    final json = <String, dynamic>{
      if (includeId) 'id': id,
      'title': title,
      'teacher': teacher,
      'date': date.toIso8601String(),
    };

    return json;
  }

  factory AttendanceSetModel.fromClass(AttendanceSet set) {
    return AttendanceSetModel(
      id: set.id,
      title: set.title,
      teacher: set.teacher,
      date: set.date,
    );
  }
}
