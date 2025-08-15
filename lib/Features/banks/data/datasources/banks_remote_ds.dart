import 'package:dartz/dartz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/banks/data/models/bank_m.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/buckets/domain/usecases/delete_bank_files_uc.dart';
import 'package:moatmat_teacher/Features/buckets/domain/usecases/upload_file_uc.dart';
import 'package:moatmat_teacher/Features/tests/data/models/video_m.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/add_video_uc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/entites/teacher_data.dart';

abstract class BanksRemoteDS {
  //
  Stream<String> uploadBank({
    required Bank bank,
  });
  //s
  Stream<String> updateBank({
    required Bank bank,
  });
  //
  Future<Unit> deleteBank({
    required int bankId,
  });
  //
  Future<Bank?> getBankById({
    required int bankId,
    required bool update,
  });
  //
  Future<List<Bank>> getBanksByIds({
    required List<int> ids,
    required bool update,
  });
  //
  Future<List<Bank>> getMyBanks({required bool update});
}

class BanksRemoteDSImpl implements BanksRemoteDS {
  @override
  Stream<String> uploadBank({required Bank bank}) async* {
    //
    bool visible = bank.properties.visible ?? false;
    //
    final client = Supabase.instance.client;
    //
    final json = BankModel.fromClass(bank).toJson();
    //--------------------------------------------------------------------
    // set up bank id
    var res = await client.from("banks").insert(json).select();
    //
    bank = bank.copyWith(
      id: res[0]["id"],
      properties: bank.properties.copyWith(visible: false),
    );
    //--------------------------------------------------------------------
    late Map model;
    await for (var newBank in uploadBankFiles(bank: bank)) {
      if (newBank is String) {
        yield newBank;
      }
      if (newBank is Bank) {
        //
        final properties = newBank.properties.copyWith(visible: visible);
        //
        model = BankModel.fromClass(
          newBank.copyWith(properties: properties),
        ).toJson();
      }
    }
    //--------------------------------------------------------------------
    // update bank
    await client.from("banks").update(model).eq("id", bank.id);
    //
    yield "تم الرفع";
  }

  Stream<dynamic> uploadBankFiles({required Bank bank}) async* {
    //
    int length = bank.questions.length;
    int filesLength = bank.information.files?.length ?? 0;
    //
    var newBank = bank;
    // Bank Video

    // upload bank videos
    List<Video> uploadedVideos = [];
    //
    for (var video in newBank.information.videos ?? []) {
      bool isLocal = video.url.startsWith("/");
      //
      String finalUrl = video.url;
      //
      if (isLocal) {
        //
        yield "رفع فيديو جديد...";
        //
        final uploadRes = await locator<UploadFileUC>().call(
          bucket: "banks",
          material: newBank.information.material,
          id: newBank.id.toString(),
          path: video.url,
          name: video.url.split('/').last,
        );
        //
        if (uploadRes.isLeft()) {
          print("❌ فشل في رفع الفيديو: $uploadRes");
          continue;
        }
        //
        finalUrl = uploadRes.getOrElse(() => "");
        //
        print("✅ تم رفع الفيديو، الرابط: $finalUrl");
        //
        if (finalUrl.startsWith("/")) {
          print("⚠️ الرابط الناتج ما زال محليًا، لن يتم إدخاله.");
          continue;
        }
      }
      //
      if (finalUrl.startsWith("/")) {
        print("⚠️ تم تجاهل الفيديو لأن رابطه ما زال محلي: $finalUrl");
        continue;
      }
      //
      final addedVideoRes = await locator<AddVideoUc>().call(
        video: VideoModel(
          id: -1,
          url: finalUrl,
          teacherId: Supabase.instance.client.auth.currentUser!.id,
        ),
      );
      //
      if (addedVideoRes.isLeft()) {
        print("❌ فشل في إدخال الفيديو بجدول videos: $addedVideoRes");
        continue;
      }
      //
      final addedVideo = addedVideoRes.getOrElse(() => Video(
            id: -1,
            url: finalUrl,
            teacherId: Supabase.instance.client.auth.currentUser!.id,
          ));
      //
      uploadedVideos.add(addedVideo);
    }
    //
    newBank = newBank.copyWith(
      information: newBank.information.copyWith(
        videos: uploadedVideos,
      ),
    );
    //
    print(newBank.information.videos?.map((v) => VideoModel.fromClass(v).toJson(addId: true)).toList());
    // upload bank images
    for (int i = 0; i < (newBank.information.images ?? []).length; i++) {
      //
      yield "رفع ملف الصورة رقم (${i + 1}/$filesLength)";
      //
      var res = await locator<UploadFileUC>().call(
        bucket: "banks",
        material: newBank.information.material,
        id: newBank.id.toString(),
        path: newBank.information.images![i],
      );
      res.fold(
        (l) {
          Fluttertoast.showToast(msg: "حصل خطأ ما اثناء محاولة رفع الصورة");
        },
        (r) {
          //
          List<String> newImages = newBank.information.images ?? [];
          //
          int index = newImages.indexOf(newBank.information.images![i]);
          //
          newImages[index] = r;
          //
          // replace links
          newBank = newBank.copyWith(
            information: newBank.information.copyWith(
              images: newImages,
            ),
          );
        },
      );
      //
    }
    //
    // upload bank files
    for (int i = 0; i < filesLength; i++) {
      //
      yield "رفع ملف pdf رقم (${i + 1}/$filesLength)";
      //
      // files
      bool con = newBank.information.files?[i] != null;
      if (con) {
        var res = await locator<UploadFileUC>().call(
          id: newBank.id.toString(),
          bucket: "banks",
          material: newBank.information.material,
          path: newBank.information.files![i],
          name: newBank.information.files![i].split('/').last,
        );
        res.fold(
          (l) {
            Fluttertoast.showToast(msg: "حصل خطأ ما اثناء محاولة رفع ملف pdf");
          },
          (r) {
            //
            List<String> newFiles = newBank.information.files ?? [];
            //
            int index = newFiles.indexOf(newBank.information.files![i]);
            //
            newFiles[index] = r;
            //
            // replace links
            newBank = newBank.copyWith(
              information: newBank.information.copyWith(
                files: newFiles,
              ),
            );
          },
        );
      }
      //
    }
    // questions files
    for (int i = 0; i < newBank.questions.length; i++) {
      //
      yield "رفع ملفات السؤال رقم (${i + 1}/$length)";
      //
      var q = newBank.questions[i];

      // video
      if (q.video != null) {
        var res = await locator<UploadFileUC>().call(
          bucket: "banks",
          material: newBank.information.material,
          id: newBank.id.toString(),
          path: q.video!,
        );
        res.fold(
          (l) => null,
          (r) {
            q = q.copyWith(video: r);
          },
        );
      }
      // Explain image
      if (q.explainImage != null) {
        var res = await locator<UploadFileUC>().call(
          bucket: "banks",
          material: newBank.information.material,
          id: newBank.id.toString(),
          path: q.explainImage!,
        );
        res.fold(
          (l) => null,
          (r) {
            q = q.copyWith(explainImage: r);
          },
        );
      }

      // image
      if (q.image != null) {
        var res = await locator<UploadFileUC>().call(
          bucket: "banks",
          material: newBank.information.material,
          id: newBank.id.toString(),
          path: q.image!,
        );
        res.fold(
          (l) => null,
          (r) {
            q = q.copyWith(image: r);
          },
        );
      }

      // answers
      for (int j = 0; j < q.answers.length; j++) {
        //
        var a = q.answers[j];
        //
        // image
        if (a.image != null) {
          var res = await locator<UploadFileUC>().call(
            bucket: "banks",
            material: newBank.information.material,
            id: newBank.id.toString(),
            path: a.image!,
          );
          res.fold(
            (l) => null,
            (r) {
              a = a.copyWith(image: r);
            },
          );
        }
        q.answers[j] = a;
      }
      newBank.questions[i] = q;
    }

    yield newBank;
  }

  @override
  Future<Unit> deleteBank({required int bankId}) async {
    //
    final client = Supabase.instance.client;
    //
    await client.from("banks").delete().eq("id", bankId);
    //
    return unit;
  }

  @override
  Future<Bank?> getBankById({required int bankId, required bool update}) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("banks").select().eq("id", bankId);
    //
    if (res.isNotEmpty) {
      //
      final bank = BankModel.fromJson(res.first);
      //
      return bank;
    }
    //
    return null;
  }

  @override
  Future<List<Bank>> getMyBanks({required bool update}) async {
    //
    final client = Supabase.instance.client;
    //
    List<Bank> banks = [];
    //
    final res = await client.from("banks").select().eq("teacher_email", locator<TeacherData>().email);
    //
    banks = res.map((e) => BankModel.fromJson(e)).toList();
    //
    return banks;
  }

  @override
  Stream<String> updateBank({required Bank bank}) async* {
    //
    final client = Supabase.instance.client;
    //
    yield "جلب بيانات البنك القديم";
    //
    var oldBank = await getBankById(bankId: bank.id, update: true);
    //
    if (oldBank != null) {
      //
      yield "حذف ملفات النبك القديم";
      //
      // delete old bank files
      locator<DeleteBankFilesUC>().call(oldBank: oldBank, newBank: bank);
    }
    //
    late Map model;
    //
    await for (var newBank in uploadBankFiles(bank: bank)) {
      if (newBank is String) {
        yield newBank;
      }
      if (newBank is Bank) {
        model = BankModel.fromClass(newBank).toJson();
      }
    }
    //
    await client.from("banks").update(model).eq("id", bank.id);
    //
    yield "تم الرفع";
  }

  @override
  Future<List<Bank>> getBanksByIds({
    required List<int> ids,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("banks").select().inFilter("id", ids);
    //
    if (res.isNotEmpty) {
      final banks = res.map((e) => BankModel.fromJson(e)).toList();
      return banks;
    }
    //
    return [];
  }
}
