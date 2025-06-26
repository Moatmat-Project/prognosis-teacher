import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/notifications2/domain/entities/notification.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

abstract class NotificationRepository {
  //
  Future<Either<Exception, Unit>> sendNotification({
    required String userId,
    required NotificationData notification,
  });
  //
  Future<Either<Exception, Unit>> sendBulkNotification({
    required List<String> userIds,
    required NotificationData notification,
  });
}
