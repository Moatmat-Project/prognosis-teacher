import 'package:moatmat_teacher/Features/tests/data/datasources/tests_remote_ds.dart';
import 'package:moatmat_teacher/Features/tests/data/repositories/tests_repository_impl.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/delete_test_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_my_tests_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_test_by_id_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_tests_by_ids_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/update_test_uc.dart';

import 'package:moatmat_teacher/Features/tests/domain/usecases/upload_test_uc.dart';

import 'app_inj.dart';

injectTests() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<UploadTestUC>(
    () => UploadTestUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<UpdateTestUC>(
    () => UpdateTestUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTestByIdUC>(
    () => GetTestByIdUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetTestsByIdsUC>(
    () => GetTestsByIdsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetMyTestsUC>(
    () => GetMyTestsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteTestsUC>(
    () => DeleteTestsUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<TestsRepository>(
    () => TestsRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<TestsRemoteDS>(
    () => TestsRemoteDSImpl(),
  );
}
