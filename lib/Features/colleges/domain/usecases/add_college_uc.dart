import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Core/usecase/usecase.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_teacher/Features/colleges/domain/repository/college_repository.dart';

class AddCollegeUC implements UseCase<void, College> {
  final CollegeRepository repository;

  AddCollegeUC(this.repository);

  @override
  Future<Either<Failure, void>> call(College college) async {
    return await repository.addCollege(college);
  }
}
