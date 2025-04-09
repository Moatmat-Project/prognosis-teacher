import 'package:dartz/dartz.dart';

import '../../data/responses/get_my_students_response.dart';
import '../entities/user_data.dart';
import '../repository/students_repo.dart';

class GetMyStudentsUC {
  final StudentsRepository repository;

  GetMyStudentsUC({required this.repository});

  Future<Either<Exception, GetMyStudentsResponse>> call({
    bool excludeCourseSubscribers = false,
    bool excludeBanks = false,
    bool excludeTests = false,
  }) {
    return repository.getMyStudents(
      excludeBanks: excludeBanks,
      excludeTests: excludeTests,
      excludeCourseSubscribers: excludeCourseSubscribers,
    );
  }
}
