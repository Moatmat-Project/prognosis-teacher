import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/attendance/data/models/attendance_record_model.dart';
import 'package:moatmat_teacher/Features/attendance/data/models/attendance_set_model.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/attendance_record.dart';

abstract class AttendanceLocalDS {
  //
  Future<List<AttendanceSet>> getAttendanceSets();
  //
  Future<void> createAttendanceSet({required AttendanceSet set});
  //
  Future<void> updateAttendanceSet({required AttendanceSet set});
  //
  Future<void> deleteAttendanceSet({required int id});
  //
  Future<List<AttendanceRecord>> getAttendanceSetRecords({required int id});
  //
  Future<Unit> setAttendanceSetRecords({required List<AttendanceRecord> attendanceSetRecord, required int setId});
}

class AttendanceLocalDSImpl implements AttendanceLocalDS {
  final SharedPreferences prefs;
  final String _key = "attendance_sets";
  final String _keyRecords = "attendance_records";

  AttendanceLocalDSImpl({required this.prefs});

  @override
  Future<void> createAttendanceSet({required AttendanceSet set}) async {
    //
    final sets = await getAttendanceSets();
    //
    sets.add(AttendanceSetModel.fromClass(set));
    //
    final json = sets.map((e) => jsonEncode(AttendanceSetModel.fromClass(e).toJson(includeId: true))).toList();
    //
    await prefs.setStringList(_key, json);
  }

  @override
  Future<void> deleteAttendanceSet({required int id}) async {
    //
    final sets = await getAttendanceSets();
    //
    sets.removeWhere((element) => element.id == id);
    //
    final json = sets.map((e) => jsonEncode(AttendanceSetModel.fromClass(e).toJson(includeId: true))).toList();
    //
    await setAttendanceSetRecords(attendanceSetRecord: [], setId: id);
    //
    await prefs.setStringList(_key, json);
  }

  @override
  Future<List<AttendanceSet>> getAttendanceSets() async {
    //
    final json = prefs.getStringList(_key);
    //
    if (json == null) {
      return [];
    }

    //
    return json.map((e) => AttendanceSetModel.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<void> updateAttendanceSet({required AttendanceSet set}) async {
    //
    final sets = await getAttendanceSets();
    //
    final index = sets.indexWhere((element) => element.id == set.id);
    //
    sets[index] = AttendanceSetModel.fromClass(set);
    //
    final json = sets.map((e) => jsonEncode(AttendanceSetModel.fromClass(e).toJson(includeId: true))).toList();
    //
    await prefs.setStringList(_key, json);
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceSetRecords({required int id}) async {
    //
    final json = prefs.getStringList(_keyRecords);
    //
    if (json == null) {
      return [];
    }
    //
    final records = json.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    //
    final filtered = records.where((element) => element["attendance_set_id"] == id.toString()).toList();
    //
    return filtered.map((e) => AttendanceRecordModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> setAttendanceSetRecords({required List<AttendanceRecord> attendanceSetRecord, required int setId}) async {
    //
    final json = prefs.getStringList(_keyRecords);
    //
    List<Map<String, dynamic>> records = [];
    //
    if (json != null) {
      records = json.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    }
    //
    records.removeWhere((element) => element["attendance_set_id"] == setId.toString());
    //
    records.addAll(attendanceSetRecord.map((e) => AttendanceRecordModel.fromClass(e).toJson(includeId: true)));
    //
    final jsonEncoded = records.map((e) => jsonEncode(e)).toList();
    //
    await prefs.setStringList(_keyRecords, jsonEncoded);
    return unit;
  }
}
