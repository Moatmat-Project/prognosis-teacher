import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/reposrt_data.dart';

abstract class ReportsRepository {
  //
  Future<Either<Exception, List<ReportData>>> getReports();
  //
  Future<Either<Exception, Unit>> deleteReport({required ReportData reportData});
}
