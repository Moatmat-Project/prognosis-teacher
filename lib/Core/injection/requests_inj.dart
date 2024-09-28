import 'package:moatmat_teacher/Features/requests/data/datasources/requests_ds.dart';
import 'package:moatmat_teacher/Features/requests/data/repository/requests_repo_impl.dart';
import 'package:moatmat_teacher/Features/requests/domain/repository/requests_repo.dart';
import 'package:moatmat_teacher/Features/requests/domain/usecases/get_requests_uc.dart';
import 'package:moatmat_teacher/Features/requests/domain/usecases/send_request_uc.dart';

import 'app_inj.dart';

injectRequests() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<GetRequestsUC>(
    () => GetRequestsUC(
      repository: locator(),
    ),
  );
  locator.registerFactory<SendRequestUC>(
    () => SendRequestUC(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<RequestRepository>(
    () => RequestsRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<RequestsDS>(
    () => RequestsDSImpl(),
  );
}
