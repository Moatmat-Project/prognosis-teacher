import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/requests/domain/entities/request.dart';

abstract class RequestRepository {
  //
  Future<Either<Exception, Stream>> sendRequest(TeacherRequest request);
  //
  Future<Either<Exception, List<TeacherRequest>>> getRequests();
}
