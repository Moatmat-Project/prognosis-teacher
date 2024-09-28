import 'package:moatmat_teacher/Features/scanner/data/datasources/scanner_remote_ds.dart';
import 'package:moatmat_teacher/Features/scanner/data/repository/scanner_repo_impl.dart';
import 'package:moatmat_teacher/Features/scanner/domain/repository/scanner_repo.dart';
import 'package:moatmat_teacher/Features/scanner/domain/usecases/delete_outer_tests_uc.dart';
import 'package:moatmat_teacher/Features/scanner/domain/usecases/upload_results_uc.dart';

import '../../Features/outer_tests/domain/usecases/get_outer_tests_uc.dart';
import '../../Features/scanner/domain/usecases/fetch_paper_uc.dart';
import '../../Features/scanner/domain/usecases/get_paper_data_uc.dart';
import 'app_inj.dart';

injectScanner() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetPaperDataUC>(
    () => GetPaperDataUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<FetchPaperUC>(
    () => FetchPaperUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<UploadResultsUC>(
    () => UploadResultsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteOuterTestsUC>(
    () => DeleteOuterTestsUC(
      repository: locator(),
    ),
  );

}

void injectRepo() {
  locator.registerFactory<ScannerRepository>(
    () => ScannerRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<ScannerRemoteDataSource>(
    () => ScannerRemoteDataSourceImpl(),
  );
}
