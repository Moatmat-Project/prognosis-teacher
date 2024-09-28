import 'package:dartz/dartz.dart';

import '../entites/update_info.dart';
import '../repository/update_repository.dart';

class CheckUpdateStateUC {
  final UpdateRepository repository;

  CheckUpdateStateUC({required this.repository});
  Future<Either<Exception, UpdateInfo>> call() {
    return repository.checkUpdateState();
  }
}
