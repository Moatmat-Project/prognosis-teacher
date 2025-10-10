import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/school/domain/entities/school.dart';
 
import '../../../../Core/errors/exceptions.dart';

abstract class SchoolRepository {
  Future<Either<Failure, List<School>>> getSchool();
}
