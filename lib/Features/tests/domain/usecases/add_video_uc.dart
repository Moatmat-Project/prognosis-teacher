import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';
import 'package:moatmat_teacher/Features/tests/domain/repositories/tests_repository.dart';

class AddVideoUc {
  final TestsRepository repository;

  AddVideoUc({required this.repository});

  Future<Either<Exception, int>> call({
    required Video video,
  }) async {
    print('type inside AddVideoUc: ${video.runtimeType}');

    return await repository.addVideo(
      video: video,
    );
  }
}