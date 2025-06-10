import 'package:dartz/dartz.dart';
import '../../domain/entities/reposrt_data.dart';
import '../../domain/repository/reports_repository.dart';
import '../datasources/reports_ds.dart';

class ReportRepositoryImpl implements ReportsRepository {
  final ReportsDataSource dataSource;

  ReportRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Exception, List<ReportData>>> getReports() async {
    try {
      var res = await dataSource.getReports();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteReport({
    required ReportData reportData,
  }) async {
    try {
      await dataSource.deleteReport(reportData: reportData);
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
