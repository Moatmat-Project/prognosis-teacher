import 'package:dartz/dartz.dart';

import '../../domain/entites/update_info.dart';
import '../../domain/repository/update_repository.dart';
import '../datasources/update_remote_ds.dart';

class UpdateRepositoryImpl implements UpdateRepository {
  final UpdateRemoteDS dataSource;

  UpdateRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Exception, UpdateInfo>> checkUpdateState() async {
    try {
      var res = await dataSource.checkUpdateState();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
