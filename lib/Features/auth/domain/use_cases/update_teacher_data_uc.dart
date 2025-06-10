import 'package:dartz/dartz.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entites/teacher_data.dart';
import '../repository/teachers_repository.dart';

class UpdateTeacherDataUC {
  final TeacherRepository repository;

  UpdateTeacherDataUC({required this.repository});
  Future<Either<Failure, Unit>> call({required TeacherData teacherData}) async {
    return await repository.updateTeacherData(teacherData: teacherData);
  }
}
