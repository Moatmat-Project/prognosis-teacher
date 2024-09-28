import 'package:dartz/dartz.dart';

import '../entities/user_data.dart';
import '../repository/students_repo.dart';

class SearchInMyStudentsUC {
  final StudentsRepository repository;

  SearchInMyStudentsUC({required this.repository});

  Future<Either<Exception, List<UserData>>> call({
    required String text,
    required bool update,
  }) {
    return repository.searchInMyStudents(text: text, update: update);
  }
}
