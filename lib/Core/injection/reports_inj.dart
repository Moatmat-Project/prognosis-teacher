import 'package:moatmat_teacher/Features/reports/domain/usecases/delete_report_uc.dart';

import '../../Features/reports/data/datasources/reports_ds.dart';
import '../../Features/reports/data/repository/repository.dart';
import '../../Features/reports/domain/repository/reports_repository.dart';
import '../../Features/reports/domain/usecases/get_reports_uc.dart';
import 'app_inj.dart';

injectReports() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetReportsUC>(
    () => GetReportsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteReportUC>(
    () => DeleteReportUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<ReportsRepository>(
    () => ReportRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<ReportsDataSource>(
    () => ReportsDataSourceImple(client: locator()),
  );
}
