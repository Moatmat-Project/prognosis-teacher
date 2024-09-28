import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/repository/outer_tests_repository.dart';

import '../../../../Core/errors/exceptions.dart';

class DeleteOuterTestUseCase {
  final OuterTestsRepository repository;

  DeleteOuterTestUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required int id}) async {
    return repository.deleteOuterTest(id: id);
  }
}
