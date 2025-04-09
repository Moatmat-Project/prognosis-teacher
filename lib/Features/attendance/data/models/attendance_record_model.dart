import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_record.dart';

class AttendanceRecordModel extends AttendanceRecord {
  const AttendanceRecordModel({
    required super.id,
    required super.attendanceSetId,
    required super.studentName,
    required super.studentId,
    required super.date,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'],
      attendanceSetId: json['attendance_set_id'].toString(),
      studentName: json['student_name'].toString(),
      studentId: json['student_id'].toString(),
      date: DateTime.parse(json['date']),
    );
  }
  factory AttendanceRecordModel.fromStatisticsQuery(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: 0,
      attendanceSetId: json["attendance_set_id"].toString(),
      studentName: "",
      studentId: json["student_id"].toString(),
      date: DateTime.now(),
    );
  }
  Map<String, dynamic> toJson({bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      'attendance_set_id': attendanceSetId,
      'student_name': studentName,
      'student_id': studentId,
      'date': date.toIso8601String(),
    };
  }

  factory AttendanceRecordModel.fromClass(AttendanceRecord record) {
    return AttendanceRecordModel(
      id: record.id,
      attendanceSetId: record.attendanceSetId,
      studentName: record.studentName,
      studentId: record.studentId,
      date: record.date,
    );
  }
}
