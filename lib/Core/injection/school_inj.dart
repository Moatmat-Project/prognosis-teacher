import 'package:moatmat_teacher/Features/school/data/datasources/ds.dart';
import 'package:moatmat_teacher/Features/school/data/repository/repository.dart';
import 'package:moatmat_teacher/Features/school/domain/repository/repository.dart';
import 'package:moatmat_teacher/Features/school/domain/usecases/get_school_uc.dart';

import 'app_inj.dart';

injectSchools() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetSchoolUc>(
    () => GetSchoolUc(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<SchoolRepository>(
    () => SchoolRepositoryImpl(
      dataSoucre: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<SchoolDataSoucre>(
    () => SchoolDataSoucreImpl(client: locator()),
  );
}
