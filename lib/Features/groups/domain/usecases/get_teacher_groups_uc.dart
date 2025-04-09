import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';
import '../entities/group.dart';

class GetTeacherGroupsUc {
  final GroupsRepository repository;

  GetTeacherGroupsUc({required this.repository});

  Future<Either<Exception, List<Group>>> call({required String teacherEmail}) {
    return repository.getTeacherGroups(teacherEmail: teacherEmail);
  }
}
