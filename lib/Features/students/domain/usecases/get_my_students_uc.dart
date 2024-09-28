import 'package:dartz/dartz.dart';

import '../entities/user_data.dart';
import '../repository/students_repo.dart';

class GetMyStudentsUC {
  final StudentsRepository repository;

  GetMyStudentsUC({required this.repository});

  Future<Either<Exception, List<UserData>>> call({ required bool update}) {
    return repository.getMyStudents(update: update);
  }
}
