import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:moatmat_teacher/Core/services/encryption_s.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

class AttendanceRecord extends Equatable {
  final int id;

  final String attendanceSetId;
  final String studentName;
  final String studentId;

  final DateTime date;

  const AttendanceRecord({
    required this.id,
    required this.attendanceSetId,
    required this.studentName,
    required this.studentId,
    required this.date,
  });

  factory AttendanceRecord.fromQrValue(String qr, String attendanceSetId) {
    final jsonData = json.decode(EncryptionService.decryptData(qr));
    return AttendanceRecord(
      id: 0,
      attendanceSetId: attendanceSetId,
      studentId: jsonData['id'].toString(),
      studentName: jsonData['name'],
      date: DateTime.now(),
    );
  }
  factory AttendanceRecord.fromUserData({required UserData user, required String attendanceSetId}) {
    return AttendanceRecord(
      id: 0,
      attendanceSetId: attendanceSetId,
      studentId: user.id,
      studentName: user.name,
      date: DateTime.now(),
    );
  }
  List<CellValue> toExcelRow() {
    List<CellValue> cells = [];
    // 1 - id
    cells.add(TextCellValue(studentId));
    // 2 - name
    cells.add(TextCellValue(studentName));
    // 7 - date
    cells.add(TextCellValue(date.toString().substring(0, 10)));
    // 8 - time
    cells.add(TextCellValue(date.toString().substring(11, 19)));
    return cells;
  }

  AttendanceRecord copyWith({
    int? id,
    String? attendanceSetId,
    String? studentName,
    String? studentId,
    DateTime? date,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      attendanceSetId: attendanceSetId ?? this.attendanceSetId,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [
        id,
        studentName,
        studentId,
        attendanceSetId,
        date,
      ];
}
