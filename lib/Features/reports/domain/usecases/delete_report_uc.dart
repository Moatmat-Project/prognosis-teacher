import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/reports/domain/entities/reposrt_data.dart';

import '../../../../Core/errors/exceptions.dart';
import '../repository/reports_repository.dart';

class DeleteReportUC {
  final ReportsRepository repository;

  DeleteReportUC({required this.repository});
  Future<Either<Exception, Unit>> call({
    required ReportData reportData,
  }) async {
    return repository.deleteReport(
      reportData: reportData,
    );
  }
}
