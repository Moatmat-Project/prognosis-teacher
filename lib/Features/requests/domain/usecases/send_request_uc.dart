import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/requests/domain/entities/request.dart';
import 'package:moatmat_teacher/Features/requests/domain/repository/requests_repo.dart';

class SendRequestUC {
  final RequestRepository repository;

  SendRequestUC({required this.repository});

  Future<Either<Exception, Stream>> call(TeacherRequest request) {
    return repository.sendRequest(request);
  }
}
