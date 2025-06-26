import 'package:moatmat_teacher/Features/notifications2/data/datasources/notifications_ds.dart';
import 'package:moatmat_teacher/Features/notifications2/data/repository/repository_impl.dart';
import 'package:moatmat_teacher/Features/notifications2/domain/repository/repository.dart';
import 'package:moatmat_teacher/Features/notifications2/domain/usecases/send_bulk_notification_uc.dart';
import 'package:moatmat_teacher/Features/notifications2/domain/usecases/send_notification_uc.dart';

import 'app_inj.dart';

injectNotifications2() {
  injectDS();
  injectRepo();
  injectUC();
}

void injectUC() {
  locator.registerFactory<SendNotification>(
    () => SendNotification(
      repository: locator(),
    ),
  );
  locator.registerFactory<SendBulkNotification>(
    () => SendBulkNotification(
      repository: locator(),
    ),
  );
}

void injectRepo() {
  locator.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(
      dataSource: locator(),
    ),
  );
}

void injectDS() {
  locator.registerFactory<NotificationDS>(
    () => NotificationDSImpl(),
  );
}
