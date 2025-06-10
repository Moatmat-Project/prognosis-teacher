import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

import '../../../../Core/errors/exceptions.dart';
import '../repository/teachers_repository.dart';

class GetUsersDataByIdsUC {
  final TeacherRepository repository;

  GetUsersDataByIdsUC({required this.repository});
  Future<Either<Failure, List<UserData>>> call({
    required List<String> ids,
    bool isUuid = true,
  }) async {
    return await repository.getUsersDataByIds(
      ids: ids,
      isUuid: isUuid,
    );
  }
}
