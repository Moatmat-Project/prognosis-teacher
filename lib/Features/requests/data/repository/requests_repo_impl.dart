import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/requests/data/datasources/requests_ds.dart';
import 'package:moatmat_teacher/Features/requests/domain/entities/request.dart';
import 'package:moatmat_teacher/Features/requests/domain/repository/requests_repo.dart';

class RequestsRepositoryImpl implements RequestRepository {
  final RequestsDS dataSource;

  RequestsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Exception, List<TeacherRequest>>> getRequests() async {
    try {
      var res = await dataSource.getRequests();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Stream>> sendRequest(TeacherRequest request) async {
    try {
      return right(dataSource.sendRequest(request));
    } on Exception catch (e) {
      return left(e);
    }
  }
}
