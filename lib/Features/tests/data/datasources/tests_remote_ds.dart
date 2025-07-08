import 'package:dartz/dartz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/buckets/domain/usecases/delete_test_files_uc.dart';
import 'package:moatmat_teacher/Features/buckets/domain/usecases/upload_file_uc.dart';
import 'package:moatmat_teacher/Features/tests/data/models/comment_m.dart';
import 'package:moatmat_teacher/Features/tests/data/models/reply_comment_m.dart';
import 'package:moatmat_teacher/Features/tests/data/models/test_m.dart';
import 'package:moatmat_teacher/Features/tests/data/models/video_m.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/reply_comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/add_video_uc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/question_m.dart';

abstract class TestsRemoteDS {
  //
  Stream<String> uploadTest({
    required Test test,
  });

  //
  Stream<String> updateTest({
    required Test test,
  });
  //
  Future<Unit> deleteTest({
    required int testId,
  });
  //
  Future<Test?> getTestById({
    required int testId,
    required bool update,
  });
  Future<List<Test>> getTestsByIds({
    required List<int> ids,
    required bool update,
  });
  //
  Future<List<Test>> getMyTests({required bool update});
  //
  Future<Video> addVideo({
    required Video video,
  });
  //
  Future<List<Comment>> getComment({
    required int videoId,
  });
  //
  Future<List<ReplyComment>> getReplies({
    required int commentId,
  });
  //
  Future<Unit> deleteComment({
    required int commentId,
  });
  //
  Future<Unit> deleteReply({
    required int replyId,
  });
}

class TestsRemoteDSImpl implements TestsRemoteDS {
  @override
  Stream<String> uploadTest({required Test test}) async* {
    //
    bool visible = test.properties.visible ?? false;
    //
    final client = Supabase.instance.client;
    //
    final json = TestModel.fromClass(test).toJson();
    //--------------------------------------------------------------------
    // set up test id
    var res = await client.from("tests").insert(json).select();
    //
    test = test.copyWith(
      id: res[0]["id"],
      properties: test.properties.copyWith(visible: false),
    );
    //--------------------------------------------------------------------
    //

    late Map model;
    await for (var newTest in uploadTestFile(test: test)) {
      if (newTest is String) {
        yield newTest;
      }
      if (newTest is Test) {
        //
        final properties = newTest.properties.copyWith(visible: visible);
        //
        model = TestModel.fromClass(
          newTest.copyWith(properties: properties),
        ).toJson();
        print("Model in uploadTestFile : $model");
        //
      }
    }
    //--------------------------------------------------------------------
    // update test
    await client.from("tests").update(model).eq("id", test.id);
    //
    yield "تم الرفع";
  }

  Stream<dynamic> uploadTestFile({required Test test}) async* {
    //
    int length = test.questions.length;
    int filesLength = test.information.files?.length ?? 0;
    //
    var newTest = test;
    //

    // upload test videos
    for (int i = 0; i < (newTest.information.videos ?? []).length; i++) {
      //
      yield "رفع ملف المقطع رقم (${i + 1}/$filesLength)";
      //
      var uploadRes = await locator<UploadFileUC>().call(
        bucket: "tests",
        material: newTest.information.material,
        id: newTest.id.toString(),
        path: newTest.information.videos![i].url,
      );
      //
      if (uploadRes.isLeft()) {
        Fluttertoast.showToast(msg: "حصل خطأ ما اثناء محاولة رفع مقطع الفيديو");
        continue;
      }
      //
      final client = Supabase.instance.client;
      //
      List<Video> newVideos = newTest.information.videos ?? [];
      //
      final uploadedUrl = uploadRes.getOrElse(() => "");
      //
      final addedVideoRes = await locator<AddVideoUc>().call(
        video: VideoModel(
          id: -1,
          url: uploadedUrl,
          teacherId: client.auth.currentUser!.id,
        ),
      );
      //
      if (addedVideoRes.isLeft()) {
        Fluttertoast.showToast(msg: "حصل خطأ ما اثناء محاولة حفظ الفيديو");
        continue;
      }
      //
      final video = addedVideoRes.getOrElse(
        () => Video(
          id: -1,
          url: "",
          teacherId: client.auth.currentUser!.id,
        ),
      );
      //
      print("id : ${video.id} ,url : ${video.url} , teacher id : ${video.teacherId}");
      //
      newVideos[i] = video;
      //
      newTest = newTest.copyWith(
        information: newTest.information.copyWith(videos: newVideos),
      );
    }
    // upload test images
    for (int i = 0; i < (newTest.information.images ?? []).length; i++) {
      //
      yield "رفع ملف الصورة رقم (${i + 1}/$filesLength)";
      //
      var res = await locator<UploadFileUC>().call(
        bucket: "tests",
        material: newTest.information.material,
        id: newTest.id.toString(),
        path: newTest.information.images![i],
      );
      res.fold(
        (l) {},
        (r) {
          //
          List<String> newImages = newTest.information.images ?? [];
          //
          int index = newImages.indexOf(newTest.information.images![i]);
          //
          newImages[index] = r;
          //
          // replace links
          newTest = newTest.copyWith(
            information: newTest.information.copyWith(
              images: newImages,
            ),
          );
        },
      );
      //
    }
    //
    // upload test files
    for (int i = 0; i < filesLength; i++) {
      //
      yield "رفع ملف pdf رقم (${i + 1}/$filesLength)";
      //
      // files
      bool con = newTest.information.files?[i] != null;
      if (con) {
        var res = await locator<UploadFileUC>().call(
          id: newTest.id.toString(),
          bucket: "tests",
          material: newTest.information.material,
          path: newTest.information.files![i],
        );
        res.fold(
          (l) {},
          (r) {
            //
            List<String> newFiles = newTest.information.files ?? [];
            //
            int index = newFiles.indexOf(newTest.information.files![i]);
            //
            newFiles[index] = r;
            //
            // replace links
            newTest = newTest.copyWith(
              information: newTest.information.copyWith(
                files: newFiles,
              ),
            );
          },
        );
      }
      //
    }

    // questions files
    for (int i = 0; i < newTest.questions.length; i++) {
      //
      yield "رفع ملفات السؤال رقم (${i + 1}/$length)";
      //
      var q = newTest.questions[i];

      // video
      if (q.video != null) {
        var res = await locator<UploadFileUC>().call(
          bucket: "tests",
          material: newTest.information.material,
          id: newTest.id.toString(),
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
          bucket: "tests",
          material: newTest.information.material,
          id: newTest.id.toString(),
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
          bucket: "tests",
          material: newTest.information.material,
          id: newTest.id.toString(),
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
            bucket: "tests",
            material: newTest.information.material,
            id: newTest.id.toString(),
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
      newTest.questions[i] = QuestionModel.fromClass(q);
    }

    yield newTest;
  }

  @override
  Future<List<Test>> getMyTests({required bool update}) async {
    //
    final client = Supabase.instance.client;
    //
    List<Test> tests = [];
    //
    final res = await client.from("tests").select().eq("teacher_email", locator<TeacherData>().email);
    //
    tests = res.map((e) => TestModel.fromJson(e)).toList();
    //
    return tests;
  }

  @override
  Future<Test?> getTestById({required int testId, required bool update}) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("tests").select().eq("id", testId);
    //
    if (res.isNotEmpty) {
      final test = TestModel.fromJson(res.first);
      return test;
    }
    //
    throw Exception("لم يتم العثور على بيانات الاختبار");
  }

  @override
  Future<Unit> deleteTest({required int testId}) async {
    //
    final client = Supabase.instance.client;
    //
    await client.from("tests").delete().eq("id", testId);
    //
    return unit;
  }

  @override
  Stream<String> updateTest({required Test test}) async* {
    //
    //
    final client = Supabase.instance.client;
    //
    yield "جلب بيانات الاختبار القديم";
    //
    var oldTest = await getTestById(testId: test.id, update: true);
    //
    if (oldTest != null) {
      //
      yield "حذف ملفات الاختبار القديم";
      //
      locator<DeleteTestFilesUC>().call(oldTest: oldTest, newTest: test);
    }
    //
    late Map model;
    //
    await for (var newTest in uploadTestFile(test: test)) {
      if (newTest is String) {
        yield newTest;
      }
      if (newTest is Test) {
        model = TestModel.fromClass(newTest).toJson();
      }
    }
    //
    await client.from("tests").update(model).eq("id", test.id);
    //
    yield "تم الرفع";
  }

  @override
  Future<List<Test>> getTestsByIds({
    required List<int> ids,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("tests").select().inFilter("id", ids);
    //
    if (res.isNotEmpty) {
      final test = res.map((e) => TestModel.fromJson(e)).toList();
      return test;
    }
    //
    return [];
  }

  @override
  Future<Video> addVideo({
    required Video video,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final existing = await client.from("videos").select().eq("url", video.url).maybeSingle();
    //
    if (existing != null) {
      return VideoModel.fromJson(existing);
    }
    //
    Map videoJson = VideoModel.fromClass(video).toJson();
    //
    var res = await client.from("videos").insert(videoJson).select().limit(1);
    //
    return VideoModel.fromJson(res.first);
  }

  @override
  Future<List<Comment>> getComment({required int videoId}) async {
    //
    final client = Supabase.instance.client;
    //
    var res = await client.from('get_comment_view').select().eq('video_id', videoId);
    //
    List<Comment> comments = res
        .map(
          (e) => CommentModel.fromJson(e),
        )
        .toList();
    //
    return comments;
  }

  @override
  Future<List<ReplyComment>> getReplies({required int commentId}) async {
    //
    final client = Supabase.instance.client;
    //
    var res = await client.from('get_replies_view').select().eq('comment_id', commentId);
    //
    List<ReplyComment> replies = res
        .map(
          (e) => ReplyCommentModel.fromJson(e),
        )
        .toList();
    //
    return replies;
  }

  @override
  Future<Unit> deleteComment({
    required int commentId,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    await client.from('comment').delete().eq('id', commentId);
    //
    return unit;
  }

  @override
  Future<Unit> deleteReply({
    required int replyId,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    await client.from('comment_reply').delete().eq('id', replyId);
    //
    return unit;
  }
}
