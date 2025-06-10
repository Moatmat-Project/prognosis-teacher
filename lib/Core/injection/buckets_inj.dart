import 'package:moatmat_teacher/Features/buckets/data/datasources/buckets_remote_ds.dart';
import 'package:moatmat_teacher/Features/buckets/data/repository/buckets_repo_impl.dart';
import 'package:moatmat_teacher/Features/buckets/domain/repository/buckets_repo.dart';
import 'package:moatmat_teacher/Features/buckets/domain/usecases/delete_test_files_uc.dart';

import '../../Features/buckets/domain/usecases/delete_bank_files_uc.dart';
import '../../Features/buckets/domain/usecases/delete_file_uc.dart';
import '../../Features/buckets/domain/usecases/upload_file_uc.dart';
import 'app_inj.dart';

injectBuckets() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<UploadFileUC>(
    () => UploadFileUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteFileUC>(
    () => DeleteFileUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteBankFilesUC>(
    () => DeleteBankFilesUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteTestFilesUC>(
    () => DeleteTestFilesUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<BucketsRepository>(
    () => BucketsRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<BucketsRemoteDS>(
    () => BucketsRemoteDSImpl(),
  );
}
