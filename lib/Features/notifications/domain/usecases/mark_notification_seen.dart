import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationSeenUseCase {
  final NotificationsRepository repository;

  MarkNotificationSeenUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(String notificationId) async {
    return await repository.markNotificationAsSeen(notificationId);
  }
}
