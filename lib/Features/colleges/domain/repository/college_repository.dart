import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';

abstract class CollegeRepository {
  Future<Either<Failure, void>> addCollege(College college);
  Future<Either<Failure, void>> editCollege(College college);
  Future<Either<Failure, List<College>>> getAllColleges();
  Future<Either<Failure, List<College>>> getCollegesBySchoolId(int schoolId);
  Future<Either<Failure, void>> deleteCollege(int id);
}
