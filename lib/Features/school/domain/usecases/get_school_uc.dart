import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/school/domain/repository/repository.dart';
 import 'package:moatmat_teacher/Features/school/domain/entities/school.dart';
 
class GetSchoolUc {
  final SchoolRepository repository;

  GetSchoolUc({required this.repository});

  Future<Either<Failure, List<School>>> call() async {
    return await repository.getSchool();
  }
}
