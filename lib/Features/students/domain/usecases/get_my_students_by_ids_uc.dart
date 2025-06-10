import 'package:dartz/dartz.dart';

import '../entities/user_data.dart';
import '../repository/students_repo.dart';

class GetMyStudentsByIdsUC {
  final StudentsRepository repository;

  GetMyStudentsByIdsUC({required this.repository});

  Future<Either<Exception, List<UserData>>> call({required List<String> ids}) {
    return repository.getMyStudentsByIds(ids: ids);
  }
}
