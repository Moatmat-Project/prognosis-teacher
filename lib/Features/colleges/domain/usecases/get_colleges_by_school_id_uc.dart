import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Core/usecase/usecase.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_teacher/Features/colleges/domain/repository/college_repository.dart';

class GetCollegesBySchoolIdUC implements UseCase<List<College>, int> {
  final CollegeRepository repository;

  GetCollegesBySchoolIdUC(this.repository);

  @override
  Future<Either<Failure, List<College>>> call(int schoolId) async {
    return await repository.getCollegesBySchoolId(schoolId);
  }
}
