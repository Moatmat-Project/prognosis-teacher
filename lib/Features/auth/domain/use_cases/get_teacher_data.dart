import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/teacher_data.dart';
import '../repository/teachers_repository.dart';

class GetTeacherDataUC {
  final TeacherRepository repository;

  GetTeacherDataUC({required this.repository});
  Future<Either<Failure, TeacherData>> call({String? email}) async {
    return await repository.getTeacherData(email: email);
  }
}
