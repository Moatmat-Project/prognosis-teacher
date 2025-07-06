import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

class AddListToGroupUc {
  final GroupsRepository repository;

  AddListToGroupUc({required this.repository});
  // add to group
  Future<Either<Exception, Unit>> call({
    required int groupId,
    required List<GroupItem> items,
  }) {
    return repository.addStudentsToGroup(groupId: groupId, items: items);
  }
}