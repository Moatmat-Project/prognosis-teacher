import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

import '../entities/group_item.dart';

class AddToGroupUc {
  final GroupsRepository repository;

  AddToGroupUc({required this.repository});

  // add to group
  Future<Either<Exception, Unit>> call({
    required int groupId,
    required GroupItem item,
  }) {
    return repository.addToGroup(groupId: groupId, item: item);
  }
}
