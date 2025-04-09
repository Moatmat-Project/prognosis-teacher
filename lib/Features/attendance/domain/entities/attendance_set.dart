import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';

class AttendanceSet {
  final int id;

  final String title;
  final String teacher;

  final DateTime date;

  AttendanceSet({
    required this.id,
    required this.title,
    required this.teacher,
    required this.date,
  });

  AttendanceSet copyWith({
    int? id,
    String? title,
    String? teacher,
    List<AttendanceRecord>? attendanceRecords,
    DateTime? date,
  }) {
    return AttendanceSet(
      id: id ?? this.id,
      title: title ?? this.title,
      teacher: teacher ?? this.teacher,
      date: date ?? this.date,
    );
  }
  factory AttendanceSet.empty() {
    return AttendanceSet(
      id: 0,
      title: '',
      teacher: '',
      date: DateTime.now(),
    );
  }
}
