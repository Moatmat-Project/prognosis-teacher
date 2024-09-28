import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/groups/data/datasources/groups_ds.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';
import 'package:moatmat_teacher/Features/groups/domain/repository/groups_repository.dart';

import '../../domain/entities/group.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsDS dataSource;

  GroupsRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Exception, Unit>> addToGroup({
    required int groupId,
    required GroupItem item,
  }) async {
    try {
      await dataSource.addToGroup(groupId: groupId, item: item);
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
}
