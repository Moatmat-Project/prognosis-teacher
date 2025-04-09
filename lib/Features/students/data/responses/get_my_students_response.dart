import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

class GetMyStudentsResponse {
  final List<int> banksIds;
  final List<int> testsIds;
  final List<UserData> students;

  GetMyStudentsResponse({
    required this.banksIds,
    required this.testsIds,
    required this.students,
  });
}
