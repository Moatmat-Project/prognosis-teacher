import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/data/datasources/groups_ds.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

import '../../domain/entities/group.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsDS dataSource;

  GroupsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Exception, Unit>> addStudentsToGroup({
    required int groupId,
    required List<GroupItem> items,
  }) async {
    try {
      await dataSource.addStudentsToGroup(groupId: groupId, items: items);
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Group>>> getGroups() async {
    try {
      var res = await dataSource.getGroups();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> removeFromGroup({
    required int groupId,
    required int itemId,
  }) async {
    try {
      await dataSource.removeFromGroup(groupId: groupId, itemId: itemId);
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> addGroup({required Group group}) async {
    try {
      await dataSource.addGroup(group: group);
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> removeGroup({required int groupId}) async {
    try {
      await dataSource.removeGroup(groupId: groupId);
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Group>>> getTeacherGroups({required String teacherEmail}) async {
    try {
      final response = await dataSource.getTeacherGroups(teacherEmail: teacherEmail);
      return right(response);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> setGroupTests({required int groupId, required List<int> testsIds, required bool isCourseSubscribersGroup}) async {
    try {
      await dataSource.setGroupTests(
        groupId: groupId,
        testsIds: testsIds,
        isCourseSubscribersGroup: isCourseSubscribersGroup,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
