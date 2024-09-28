import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/teacher_data.dart';
import '../repository/teachers_repository.dart';

class SignInUC {
  final TeacherRepository repository;

  SignInUC({required this.repository});
  Future<Either<Failure, TeacherData>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signIn(email: email, password: password);
  }
}
