import 'dart:convert';

import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_my_students_by_ids_uc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassificationService {
  //
  addUser(UserClassData data) async {
    //
    List<UserClassData> list = [];
    //
    list = ClassificationDS().getAll();
    //
    list.removeWhere((e) => e.id == data.id);
    //
    list.add(data);
    //
    await ClassificationDS().setAll(list);
    //
    return;
  }

  //
  UserClassData? checkIfItSaved(String userId) {
    //
    List<UserClassData> list = [];
    //
    list = ClassificationDS().getAll();
    //
    UserClassData? data;
    //
    for (var l in list) {
      if (l.id == userId) {
        data = l;
      }
    }
    //
    return data;
  }

  //
  Future<List<UserData>> getByClass(String classs) async {
    //
    List<UserClassData> list = [];
    List<UserData> users = [];
    List<String> ids = [];
    //
    list = ClassificationDS().getAll();
    //
    list = list.where((e) => e.classs == classs).toList();
    //
    ids = list.map((e) => e.id).toList();
    //
    var res = await locator<GetMyStudentsByIdsUC>().call(ids: ids);
    //
    res.fold(
      (l) {},
      (r) {
        users = r;
      },
    );
    //
    return users;
  }

  UserClassData? getById(String userId) {
    //
    List<UserClassData> list = [];
    //
    list = ClassificationDS().getAll();
    //
    list = list.where((e) => e.id == userId).toList();

    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }
}

///////////////////////

class ClassificationDS {
  List<UserClassData> getAll() {
    //
    String? str = locator<SharedPreferences>().getString("classifications");
    //
    if (str == null) return [];
    //
    List data = json.decode(str);
    //
    List<UserClassData> list = [];
    //
    for (var d in data) {
      list.add(UserClassData.fromJson(d));
    }
    //
    return list;
  }

  setAll(List<UserClassData> list) async {
    //
    List data = list.map((e) => e.toJson()).toList();
    //
    String str = json.encode(data);
    //
    await locator<SharedPreferences>().setString("classifications", str);
    //
    return;
  }
}

class UserClassData {
  final String id;
  final String classs;

  UserClassData({
    required this.id,
    required this.classs,
  });

  factory UserClassData.fromJson(Map json) {
    return UserClassData(
      id: json["id"],
      classs: json["classs"],
    );
  }

  toJson() {
    return {
      "id": id,
      "classs": classs,
    };
  }
}
