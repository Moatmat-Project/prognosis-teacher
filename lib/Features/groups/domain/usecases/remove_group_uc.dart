import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

import '../entities/group_item.dart';

class RemoveGroupUc {
  final GroupsRepository repository;

  RemoveGroupUc({required this.repository});

  // add to group
  Future<Either<Exception, Unit>> call({
    required int groupId,
  }) {
    return repository.removeGroup(groupId: groupId);
  }
}
