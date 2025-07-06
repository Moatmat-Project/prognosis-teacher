import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';

import '../entities/group.dart';

abstract class GroupsRepository {
  // get groups
  Future<Either<Exception, List<Group>>> getGroups();
  // get groups
  Future<Either<Exception, List<Group>>> getTeacherGroups({required String teacherEmail});
  // add group
  Future<Either<Exception, Unit>> addGroup({
    required Group group,
  });
  // add many students to groub
  Future<Either<Exception, Unit>> addStudentsToGroup({
    required int groupId,
    required List<GroupItem> items,
  });
  // add to group
  Future<Either<Exception, Unit>> setGroupTests({
    required int groupId,
    required List<int> testsIds,
  required  bool isCourseSubscribersGroup ,
  });
  // remove form group
  Future<Either<Exception, Unit>> removeFromGroup({
    required int groupId,
    required int itemId,
  });
  // remove form group
  Future<Either<Exception, Unit>> removeGroup({
    required int groupId,
  });
}
