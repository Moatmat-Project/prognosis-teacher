import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/requests/domain/entities/request.dart';
import 'package:moatmat_teacher/Features/requests/domain/repository/requests_repo.dart';

class GetRequestsUC {
  final RequestRepository repository;

  GetRequestsUC({required this.repository});

  Future<Either<Exception, List<TeacherRequest>>> call() {
    return repository.getRequests();
  }
}
