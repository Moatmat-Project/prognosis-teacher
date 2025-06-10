import 'package:dartz/dartz.dart';
import '../../../../Core/errors/exceptions.dart';
import '../entities/reposrt_data.dart';
import '../repository/reports_repository.dart';

class GetReportsUC {
  final ReportsRepository repository;

  GetReportsUC({required this.repository});
  Future<Either<Exception, List<ReportData>>> call() async {
    return await repository.getReports();
  }
}
