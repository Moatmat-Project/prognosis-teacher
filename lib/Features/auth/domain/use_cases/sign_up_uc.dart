import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/teacher_data.dart';
import '../repository/teachers_repository.dart';

class SignUpUC {
  final TeacherRepository repository;

  SignUpUC({required this.repository});
  Future<Either<Failure, TeacherData>> call({
    required TeacherData teacherData,
    required String password,
  }) async {
    return await repository.signUp(
      teacherData: teacherData,
      password: password,
    );
  }
}
