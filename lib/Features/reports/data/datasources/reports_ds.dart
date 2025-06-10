import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/reposrt_data.dart';
import '../models/report_d_m.dart';

abstract class ReportsDataSource {
  Future<List<ReportData>> getReports();
  //
  Future<Unit> deleteReport({required ReportData reportData});
}

class ReportsDataSourceImple implements ReportsDataSource {
  final SupabaseClient client;

  ReportsDataSourceImple({required this.client});

  @override
  Future<List<ReportData>> getReports() async {
    //
    var res = await client
        .from("reports")
        .select()
        .eq(
          "teacher",
          locator<TeacherData>().email,
        )
        .order("id");
    //
    List<ReportData> reports = [];
    //
    reports = res.map((e) => ReportDataModel.fromJson(e)).toList();
    //
    return reports;
  }

  @override
  Future<Unit> deleteReport({required ReportData reportData}) async {
    //
    await client.from("reports").delete().eq("id", reportData.id);
    //
    return unit;
  }
}
