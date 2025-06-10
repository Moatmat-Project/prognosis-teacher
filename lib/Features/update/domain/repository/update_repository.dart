import 'package:dartz/dartz.dart';

import '../entites/update_info.dart';

abstract class UpdateRepository {
  Future<Either<Exception, UpdateInfo>> checkUpdateState();
}
