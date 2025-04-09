import 'package:dartz/dartz.dart';
import '../../data/responses/get_my_students_statistics_response.dart';
import '../entities/user_data.dart';
import '../repository/students_repo.dart';

class GetMyStudentsStatisticsUc {
  final StudentsRepository repository;

  GetMyStudentsStatisticsUc({required this.repository});

  Future<Either<Exception, GetMyStudentsStatisticsResponse>> call({
    required List<UserData> students,
  }) {
    return repository.getMyStudentsStatistics(students: students);
  }
}
