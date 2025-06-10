import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

import '../entities/group.dart';
import '../entities/group_item.dart';

class GetGroupsUc {
  final GroupsRepository repository;

  GetGroupsUc({required this.repository});

  Future<Either<Exception, List<Group>>> call() {
    return repository.getGroups();
  }
}
