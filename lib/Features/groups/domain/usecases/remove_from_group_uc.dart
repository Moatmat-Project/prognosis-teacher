import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

class RemoveFromGroupUc {
  final GroupsRepository repository;

  RemoveFromGroupUc({required this.repository});

  Future<Either<Exception, Unit>> call({
    required int groupId,
    required int itemId,
  }) {
    return repository.removeFromGroup(groupId: groupId, itemId: itemId);
  }
}
