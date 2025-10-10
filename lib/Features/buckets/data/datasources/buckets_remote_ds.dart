import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/constant/materials.dart';
import '../../../../Core/functions/coders/encode.dart';
import '../../../banks/domain/entities/bank.dart';
import '../../../tests/domain/entities/test/test.dart';

abstract class BucketsRemoteDS {
  //
  Future<String> uploadFile({
    required String material,
    required String id,
    required String path,
    required String bucket,
    String? name,
  });

  Future<Unit> deleteFile({
    required String link,
    required String bucket,
  });
  //
  Future<Unit> deleteTestFiles({
    required Test oldTest,
    required Test newTest,
  });
  //
  Future<Unit> deleteBanksFiles({
    required Bank oldBank,
    required Bank newBank,
  });
}

class BucketsRemoteDSImpl implements BucketsRemoteDS {
  @override
  Future<Unit> deleteFile({
    required String link,
    required String bucket,
  }) async {
    //
    if (link.isEmpty) return unit;
    //
    final client = Supabase.instance.client;
    // Create a Storage Bucket instance
    final storage = client.storage.from(bucket);
    // generate filePath
    String filePath = linkToPath((link), bucket);
    // Delete the file
    // print(filePath);
    storage.list();
    await storage.remove([Uri.decodeFull(filePath)]);
    //
    return unit;
  }

  String linkToPath(String link, String bucket) {
    // Split the URL by "/public/"
    List<String> parts = link.split("$bucket/");
    //
    return parts[1];
  }

  @override
  Future<String> uploadFile({
    required String material,
    required String id,
    required String path,
    required String bucket,
    String? name,
  }) async {
    try {
      if (path.contains("supabase")) {
        return path;
      }
      //
      final client = Supabase.instance.client;
      //
      final storage = client.storage.from(bucket);
      //
      String filePath = await setUpFilePath(
        material: material,
        id: id,
        path: path,
        name: name,
      );
      //

      //
      await storage.upload(filePath, File(path));
      //
      return storage.getPublicUrl(Uri.decodeFull(filePath));
    } on Exception {
      return path;
    }
  }

  Future<String> setUpFilePath({
    required String material,
    required String id,
    required String path,
    String? name,
  }) async {
    //
    String folder1 = trMaterialsLst[material] ?? "main";
    //
    String type = path.split("/").last;
    //
    type = type.split(".").last;
    //
    if (name != null) {
      //
      name = encodeFileName(name);
      //
    } else {
      name = DateTime.now().toString().replaceAll(RegExp(r'[^0-9]+'), '.');
    }
    //

    //
    folder1 = folder1.replaceAll(" ", "");
    //
    return "$folder1/$id/$name.$type";
  }

  @override
  Future<Unit> deleteBanksFiles({
    required Bank oldBank,
    required Bank newBank,
  }) async {
    //
    var material = trMaterialsLst[oldBank.information.material];
    //
    var id = oldBank.id;
    //
    final path = "$material/$id/";
    //
    final client = Supabase.instance.client;
    // Create a Storage Bucket instance
    final storage = client.storage.from("banks");
    //
    var files = await storage.list(path: path);
    //
    var filesNames = files.map((e) => e.name).toList();
    //
    if (newBank.information.videos == oldBank.information.videos) {
      for (var v in oldBank.information.videos ?? []) {
        filesNames.remove(linkToFileName(v));
      }
    }
    //
    List<String?> wantedFiles = [];
    //
    if (newBank.information.files != null) {
      for (var f in newBank.information.files!) {
        if (f.contains("supabase")) {
          wantedFiles.add(linkToFileName(f));
        }
      }
    }
    if (newBank.information.videos != null) {
      for (var v in newBank.information.videos!) {
        if (v.url.contains("supabase")) {
          wantedFiles.add(linkToFileName(v.url));
        }
      }
    }
    if (newBank.information.images != null) {
      for (var m in newBank.information.images!) {
        if (m.contains("supabase")) {
          wantedFiles.add(linkToFileName(m));
        }
      }
    }

    // //
    for (int i = 0; i < newBank.questions.length; i++) {
      wantedFiles.add(linkToFileName(newBank.questions[i].image));
      wantedFiles.add(linkToFileName(newBank.questions[i].video));
      wantedFiles.add(linkToFileName(newBank.questions[i].explainImage));
      wantedFiles += newBank.questions[i].answers.map((a) {
        return linkToFileName(a.image);
      }).toList();
    }
    //
    wantedFiles.removeWhere((f) => f == null);
    //
    List<String> filesToDelete = [];
    for (var fn in filesNames) {
      if (!wantedFiles.contains(fn)) {
        filesToDelete.add(fn);
      }
    }

    await storage.remove(files.map((e) {
      String path = "$material/$id/";
      return path + e.name;
    }).toList());
    //
    return unit;
  }

  @override
  Future<Unit> deleteTestFiles({
    required Test oldTest,
    required Test newTest,
  }) async {
    //
    var material = trMaterialsLst[oldTest.information.material];
    var id = oldTest.id;
    final path = "$material/$id/";
    final client = Supabase.instance.client;
    final storage = client.storage.from("tests");
    //
    var files = await storage.list(path: path);
    //
    var filesNames = files.map((e) => e.name).toList();
    //
    List<String?> wantedFiles = [];
    //
    if (newTest.information.files != null) {
      for (var f in newTest.information.files!) {
        if (f.contains("supabase")) {
          wantedFiles.add(linkToFileName(f));
        }
      }
    }
    if (newTest.information.videos != null) {
      for (var v in newTest.information.videos!) {
        if (v.url.contains("supabase")) {
          wantedFiles.add(linkToFileName(v.url));
        }
      }
    }
    if (newTest.information.images != null) {
      for (var m in newTest.information.images!) {
        if (m.contains("supabase")) {
          wantedFiles.add(linkToFileName(m));
        }
      }
    }

    // //
    for (int i = 0; i < newTest.questions.length; i++) {
      wantedFiles.add(linkToFileName(newTest.questions[i].image));
      wantedFiles.add(linkToFileName(newTest.questions[i].video));
      wantedFiles.add(linkToFileName(newTest.questions[i].explainImage));
      wantedFiles += newTest.questions[i].answers.map((a) {
        return linkToFileName(a.image);
      }).toList();
    }
    //
    List<String> filesToDelete = [];
    //
    for (var fn in filesNames) {
      if (!wantedFiles.contains(fn)) {
        filesToDelete.add(fn);
      }
    }
    await storage.remove(filesToDelete.map((e) {
      return path + e;
    }).toList());

    return unit;
  }

  String? linkToFileName(String? link) {
    return link?.replaceAll("%", " ").split("/").last;
  }
}
