import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/attendance/data/models/attendance_record_model.dart';
import 'package:moatmat_teacher/Features/attendance/data/models/attendance_set_model.dart';
import 'package:moatmat_teacher/Features/attendance/domain/entities/attendance_set.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/attendance_record.dart';

abstract class AttendanceRemoteDS {
  //
  Future<List<AttendanceSet>> getAttendanceSets();
  //
  Future<int?> createAttendanceSet({required AttendanceSet set});
  //
  Future<Unit?> syncAttendanceSet({required AttendanceSet set, required List<AttendanceRecord> records});
  //
  Future<Unit> updateAttendanceSet({required AttendanceSet set});
  //
  Future<Unit> deleteAttendanceSet({required int id});
  //
  Future<List<AttendanceRecord>> getAttendanceSetRecords({required int id});
  Future<List<AttendanceRecord>> getStudentRecords({required String id});
  //
  Future<Unit> setAttendanceSetRecords({required List<AttendanceRecord> attendanceSetRecord, required int setId});
}

class AttendanceRemoteDSImpl implements AttendanceRemoteDS {
  final SupabaseClient client;

  AttendanceRemoteDSImpl({required this.client});

  @override
  Future<int?> createAttendanceSet({required AttendanceSet set}) async {
    //
    final json = AttendanceSetModel.fromClass(set).toJson();
    //
    final response = await client.from("attendance_sets").insert(json).select("id").single();
    //
    return response['id'] as int?;
  }

  @override
  Future<Unit> deleteAttendanceSet({required int id}) async {
    //
    await client.from("attendance_sets").delete().eq("id", id);
    //
    await client.from("attendance_records").delete().eq("attendance_set_id", id);
    //
    return unit;
  }

  @override
  Future<List<AttendanceSet>> getAttendanceSets() async {
    //
    final res = await client.from("attendance_sets").select().eq("teacher", locator<TeacherData>().email).order("date");
    //
    return res.map((e) => AttendanceSetModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> updateAttendanceSet({required AttendanceSet set}) async {
    await client.from("attendance_sets").update(AttendanceSetModel.fromClass(set).toJson()).eq("id", set.id);
    return unit;
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceSetRecords({required int id}) async {
    //
    final res = await client.from("attendance_records").select().eq("attendance_set_id", id).order("date");
    //
    return res.map((e) => AttendanceRecordModel.fromJson(e)).toList();
  }

  @override
  Future<List<AttendanceRecord>> getStudentRecords({required String id}) async {
    //
    final res = await client.from("attendance_records").select().eq("student_id", id).order("date");
    //
    return res.map((e) => AttendanceRecordModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> setAttendanceSetRecords({required List<AttendanceRecord> attendanceSetRecord, required int setId}) async {
    //
    final records = await fetchUsersNames(attendanceSetRecord);
    //
    final json = records.map((e) => AttendanceRecordModel.fromClass(e.copyWith(attendanceSetId: setId.toString())).toJson()).toList();
    //
    await client.from("attendance_records").delete().eq("attendance_set_id", setId);
    //
    await client.from("attendance_records").insert(json);
    //
    return unit;
  }

  Future<List<AttendanceRecord>> fetchUsersNames(List<AttendanceRecord> records) async {
    //
    try {
      //
      final filtered = records.where((e) => e.studentName.isEmpty).toList();
      //
      if (filtered.isEmpty) return records;
      //
      final items = await client.from("users_data").select("id,name").inFilter('id', filtered.map((e) => e.studentId).toList());
      //
      Map<String, String> mapper = {};
      for (var item in items) {
        mapper[item['id'].toString()] = item['name'].toString();
      }
      //
      for (int i = 0; i < records.length; i++) {
        if (records[i].studentName.isEmpty) {
          records[i] = records[i].copyWith(
            studentName: mapper[records[i].studentId] ?? "لم يتم العثور على الطالب!",
          );
        }
      }
      //
      return records;
    } on Exception catch (e) {
      return records;
    }
  }

  @override
  Future<Unit> syncAttendanceSet({required AttendanceSet set, required List<AttendanceRecord> records}) async {
    //
    final jsonSet = AttendanceSetModel.fromClass(set).toJson();
    //
    final response = await client.from("attendance_sets").insert(jsonSet).select("id").single();
    //
    final setId = response['id'] as int;
    //
    final jsonRecords = records.map((e) {
      return AttendanceRecordModel.fromClass(
        e.copyWith(attendanceSetId: setId.toString()),
      ).toJson();
    }).toList();
    //
    await client.from("attendance_records").insert(jsonRecords);
    //
    return unit;
  }
}
