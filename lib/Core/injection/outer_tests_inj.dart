import 'package:moatmat_teacher/Features/outer_tests/data/datasources/outer_tests_datasource.dart';
import 'package:moatmat_teacher/Features/outer_tests/data/repository/outer_tests_repository_impl.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/add_outer_test_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/delete_outer_test_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/get_outer_test_by_id_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/get_outer_tests_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/udpate_outer_test.dart';

import '../../Features/outer_tests/domain/repository/outer_tests_repository.dart';
import 'app_inj.dart';

injectOuterTests() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<AddOuterTestUseCase>(
    () => AddOuterTestUseCase(
      repository: locator(),
    ),
  );
  locator.registerFactory<DeleteOuterTestUseCase>(
    () => DeleteOuterTestUseCase(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetOuterTestByIdUseCase>(
    () => GetOuterTestByIdUseCase(
      repository: locator(),
    ),
  );
  locator.registerFactory<GetOuterTestsUseCase>(
    () => GetOuterTestsUseCase(
      repository: locator(),
    ),
  );
  locator.registerFactory<UpdateOuterTestUseCase>(
    () => UpdateOuterTestUseCase(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<OuterTestsRepository>(
    () => OuterTestsRepositoryImplement(
      datasource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<OuterTestsDatasource>(
    () => OuterTestsDatasourceImplements(),
  );
}
