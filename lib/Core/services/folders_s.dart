import 'dart:convert';

import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoldersService {
  //
  static final sp = locator<SharedPreferences>();
  //
  static testing() async {
    // var f = await SharedPreferences.getInstance();
    // await f.clear();
    // await createFolder(
    //   "all_folders2",
    //   Folder(
    //     id: 0,
    //     name: "test3",
    //     content: [],
    //     subFolders: [],
    //   ),
    // );
    // for (var f in await getFolders("all_folders2")) {
    //   await createSubFolder(
    //     "all_folders2",
    //     "test3",
    //     SubFolders(
    //       id: 0,
    //       name: "first",
    //       parent: "test3",
    //       content: [],
    //     ),
    //   );
    // }
    // for (var f in await getFolders("all_folders2")) {
    //   print(f.subFolders.first.name);
    // }
  }

  //
  // get folders
  static Future<List<Folder>> getFolders(String key) async {
    //
    String? strList = sp.getString(key);
    //
    List<Folder> foldersList = strToListFolder(strList);
    //
    return foldersList;
  }

  // add folder
  static Future<void> createFolder(String key, Folder folder) async {
    //
    var folders = await getFolders(key);
    //
    folders.add(folder);
    //
    await updateFolders(key, folders);
    //
    return;
  }

  // delete folder
  static Future<void> deleteFolder(String key, int id) async {
    //
    var folders = await getFolders(key);
    //
    folders.removeWhere((e) => e.id == id);
    //
    await updateFolders(key, folders);
    //
    return;
  }

  // update folder
  static Future<void> updateFolders(String key, List<Folder> folders) async {
    await sp.setString(key, listFolderToStr(folders));
    return;
  }

  //
  // get Sub Folders
  static Future<List<SubFolders>> getSubFolders(
    String key,
    String subKey,
  ) async {
    //
    String? strList = sp.getString(key);
    //
    List<SubFolders> foldersList = strToListSubFolder(strList, subKey);
    //
    return foldersList;
  }

  // add Sub Folder
  static Future<void> createSubFolder(
    String key, // repository
    String subKey, // folder
    SubFolders subFolder,
  ) async {
    //
    var subFolders = await getSubFolders(key, subKey);
    //
    subFolders.add(subFolder);
    //
    await updateSubFolder(key, subKey, subFolders);
    //
    return;
  }

  // delete Sub Folder
  static Future<void> deleteSubFolder(String key, String subKey, int id) async {
    //
    var subFolders = await getSubFolders(key, subKey);
    //
    subFolders.removeWhere((e) => e.id == id);
    //
    await updateSubFolder(key, subKey, subFolders);
    //
    return;
  }

  // update Sub Folder
  static Future<void> updateSubFolder(
    String key, // repo
    String subKey, // folder
    List<SubFolders> subFolders,
  ) async {
    //
    var folders = await getFolders(key);
    //
    for (int i = 0; i < folders.length; i++) {
      if (folders[i].name == subKey) {
        folders[i] = folders[i].copyWith(
          subFolders: subFolders,
        );
      }
    }
    //
    await updateFolders(key, folders);
    //
    return;
  }

  //
  //
  //
  static List<Folder> strToListFolder(String? list) {
    //
    if (list == null) return [];
    //
    List jsonList = json.decode(list);
    //
    List<Folder> folders = jsonList.map((e) => Folder.fromJson(e)).toList();
    //
    return folders;
  }

  //
  static String listFolderToStr(List<Folder> folders) {
    //
    List<Map> jsonList = List.generate(
      folders.length,
      (i) => folders[i].copyWith(id: i).toJson(),
    );
    //
    String str = json.encode(jsonList);
    //
    return str;
  }

  //
  //
  //
  static List<SubFolders> strToListSubFolder(String? list, String key) {
    //
    List<Folder> folders = strToListFolder(list);
    //
    List<SubFolders> subFolders = [];
    //
    if (folders.isEmpty) return [];
    //
    for (var f in folders) {
      if (f.name == key) {
        subFolders.addAll(f.subFolders);
        break;
      }
    }
    //
    return subFolders;
  }

  //
  static String listSubFolderToStr(List<SubFolders> folders) {
    //
    List<Map> jsonList = List.generate(
      folders.length,
      (i) => folders[i].copyWith(id: i).toJson(),
    );
    //
    String str = json.encode(jsonList);
    //
    return str;
  }

  static List<SubFolders> updateSubFolderInList(List<SubFolders> subFolders) {
    var newSubFolders = subFolders;
    //
    //
    return newSubFolders;
  }
}

class Folder {
  //
  final int id;
  //
  final String name;
  //
  final List<int> tests;
  //
  final List<int> banks;
  //
  final List<SubFolders> subFolders;

  Folder({
    required this.id,
    required this.name,
    required this.tests,
    required this.banks,
    required this.subFolders,
  });

  Folder copyWith({
    //
    int? id,
    //
    String? name,
    //
    List<int>? tests,
    //
    List<int>? banks,
    //
    List<SubFolders>? subFolders,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      tests: tests ?? this.tests,
      banks: banks ?? this.banks,
      subFolders: subFolders ?? this.subFolders,
    );
  }

  factory Folder.fromJson(Map json) {
    //
    return Folder(
      //
      id: json["id"],
      //
      name: json["name"],
      //
      tests: json["tests"].cast<int>(),
      banks: json["banks"].cast<int>(),
      //
      subFolders: List.generate(
        (json["sub_folders"] as List).length,
        (i) {
          return SubFolders.fromJson(json["sub_folders"][i]);
        },
      ),
      //
    );
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
      "tests": tests,
      "banks": banks,
      "sub_folders": List.generate(
        subFolders.length,
        (i) {
          return subFolders[i].copyWith(id: i).toJson();
        },
      ),
    };
  }
}

class SubFolders {
  //
  final int id;
  //
  final String name;
  //
  final String parent;
  //
  //
  final List<int> tests;
  //
  final List<int> banks;

  SubFolders({
    required this.id,
    required this.name,
    required this.parent,
    required this.tests,
    required this.banks,
  });

  SubFolders copyWith({
    //
    int? id,
    //
    String? name,
    //
    String? parent,
    //
    List<int>? tests,
    //
    List<int>? banks,
  }) {
    return SubFolders(
      id: id ?? this.id,
      name: name ?? this.name,
      parent: parent ?? this.parent,
      tests: tests ?? this.tests,
      banks: banks ?? this.banks,
    );
  }

  factory SubFolders.fromJson(Map json) {
    return SubFolders(
      id: json["id"],
      name: json["name"],
      parent: json["parent"],
      tests: json["tests"].cast<int>(),
      banks: json["banks"].cast<int>(),
    );
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
      "parent": parent,
      "tests": tests,
      "banks": banks,
    };
  }
}
