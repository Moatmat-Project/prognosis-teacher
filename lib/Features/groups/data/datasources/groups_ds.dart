import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/auth/domain/use_cases/get_teacher_data.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';

import '../../domain/entities/group_item.dart';

abstract class GroupsDS {
  //
  Future<List<Group>> getGroups();
  //
  Future<List<Group>> getTeacherGroups({required String teacherEmail});
  //
  Future<Unit> addGroup({
    required Group group,
  });
  //
  Future<Unit> addToGroup({
    required int groupId,
    required GroupItem item,
  });
  //
  Future<Unit> setGroupTests({
    required int groupId,
    required List<int> testsIds,
    required bool isCourseSubscribersGroup,
  });
  //
  Future<Unit> removeFromGroup({
    required int groupId,
    required int itemId,
  });
  //
  // remove form group
  Future<Unit> removeGroup({
    required int groupId,
  });
}

class GroupsDSImpl implements GroupsDS {
  @override
  Future<Unit> addToGroup({
    required int groupId,
    required GroupItem item,
  }) async {
    //
    List<Group> groups = await getGroups();
    //
    groups = List<Group>.from(groups);
    //
    for (int i = 0; i < groups.length; i++) {
      if (groups[i].id == groupId) {
        groups[i] = groups[i].copyWith(
          items: groups[i].items + [item],
        );
      }
    }
    //
    await setGroups(groups);
    //
    return unit;
  }

  @override
  Future<Unit> setGroupTests({
    required int groupId,
    required List<int> testsIds,
    required bool isCourseSubscribersGroup,
  }) async {
    if (isCourseSubscribersGroup) {
      await locator<TeacherData>().updateCourseSubscribersTests(
        testsIds,
      );
      return unit; 
    }
    //
    List<Group> groups = await getGroups();
    //
    groups = List<Group>.from(groups);
    //
    for (int i = 0; i < groups.length; i++) {
      if (groups[i].id == groupId) {
        groups[i] = groups[i].copyWith(
          testsIds: testsIds,
        );
      }
    }
    //
    await setGroups(groups);
    //
    return unit;
  }

  @override
  Future<List<Group>> getGroups() async {
    List<Group> groups = [];
    //
    groups = locator<TeacherData>().groups;
    //
    return groups;
  }

  Future<List<Group>> setGroups(List<Group> groups) async {
    //
    await locator<TeacherData>().updateGroups(
      List.generate(
        groups.length,
        (i) => groups[i].copyWith(id: i),
      ),
    );
    //
    return groups;
  }

  @override
  Future<Unit> removeFromGroup({
    required int groupId,
    required int itemId,
  }) async {
    //
    List<Group> groups = locator<TeacherData>().groups;
    //
    groups = List<Group>.from(groups);
    //
    for (int i = 0; i < groups.length; i++) {
      if (groups[i].id == groupId) {
        groups[i] = groups[i].copyWith(
          items: groups[i].items.where((e) => e.id != itemId).toList(),
        );
      }
    }
    //
    await setGroups(groups);
    //
    return unit;
  }

  @override
  Future<Unit> addGroup({required Group group}) async {
    //
    List<Group> groups = await getGroups();
    //
    groups = List<Group>.from(groups);
    //
    groups.add(group);
    //
    await setGroups(groups);
    //
    return unit;
  }

  @override
  Future<Unit> removeGroup({required int groupId}) async {
    //
    List<Group> groups = await getGroups();
    //
    groups = List<Group>.from(groups);
    //
    groups.removeWhere((g) => g.id == groupId);
    //
    await setGroups(groups);
    //
    return unit;
  }

  @override
  Future<List<Group>> getTeacherGroups({required String teacherEmail}) async {
    List<Group> groups = [];

    //
    final response = await locator<GetTeacherDataUC>().call(email: teacherEmail);
    //
    response.fold((l) {}, (r) {
      groups = r.groups;
    });
    //
    return groups;
  }
}
