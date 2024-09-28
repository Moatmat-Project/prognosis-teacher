import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/groups/data/models/group_m.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/group_item.dart';

abstract class GroupsDS {
  //
  Future<List<Group>> getGroups();
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
  Future<List<Group>> getGroups() async {
    List<Group> groups = [];
    //
    final str = locator<SharedPreferences>().getString("groups");
    //
    groups = strToListGroups(str);
    //
    return groups;
  }

  Future<List<Group>> setGroups(List<Group> groups) async {
    //
    final str = listGroupsToStr(groups);
    //
    await locator<SharedPreferences>().setString("groups", str);
    //
    return groups;
  }

  @override
  Future<Unit> removeFromGroup({
    required int groupId,
    required int itemId,
  }) async {
    //
    List<Group> groups = await getGroups();
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

  List<Group> strToListGroups(String? str) {
    //
    if (str == null) return [];
    //
    List jsonList = json.decode(str);
    //
    List<Group> groups = jsonList.map((e) {
      return GroupModel.fromJson(e);
    }).toList();
    //
    return groups;
  }

  //
  String listGroupsToStr(List<Group> groups) {
    //
    List<Map> jsonList = List.generate(
      groups.length,
      (i) {
        final model = GroupModel.fromClass(groups[i].copyWith(id: i));
        return model.toJson();
      },
    );
    //
    String str = json.encode(jsonList);
    //
    return str;
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
}
