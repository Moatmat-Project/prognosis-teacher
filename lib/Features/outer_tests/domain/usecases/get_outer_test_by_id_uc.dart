import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/repository/outer_tests_repository.dart';

import '../../../../Core/errors/exceptions.dart';
import '../entities/outer_test.dart';

class GetOuterTestByIdUseCase {
  final OuterTestsRepository repository;

  GetOuterTestByIdUseCase({required this.repository});

 Future<Either<Failure, OuterTest>>  call({required int id}) async {
    return repository.getOuterTestById(id: id);
  }
}
