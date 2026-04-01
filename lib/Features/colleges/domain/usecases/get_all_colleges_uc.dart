import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Core/usecase/usecase.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_teacher/Features/colleges/domain/repository/college_repository.dart';

class GetAllCollegesUC implements UseCase<List<College>, NoParams> {
  final CollegeRepository repository;

  GetAllCollegesUC(this.repository);

  @override
  Future<Either<Failure, List<College>>> call(NoParams params) async {
    return await repository.getAllColleges();
  }
}
