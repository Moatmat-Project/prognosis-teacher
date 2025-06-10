import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

class SetGroupTestsUC {
  final GroupsRepository repository;

  SetGroupTestsUC({required this.repository});

  // add to group
  Future<Either<Exception, Unit>> call({
    required int groupId,
    required List<int> testsIds,
    required bool isCourseSubscribersGroup,
  }) {
    return repository.setGroupTests(
      groupId: groupId,
      testsIds: testsIds,
      isCourseSubscribersGroup: isCourseSubscribersGroup,
    );
  }
}
