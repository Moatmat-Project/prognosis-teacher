import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/services/channels_s.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/auth/domain/use_cases/get_user_data.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/form_data.dart';
import 'package:moatmat_teacher/Features/students/data/models/result_m.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/answers_data.dart';
import '../../domain/entities/id_data.dart';
import '../../domain/entities/paper.dart';
import '../../domain/entities/row_bubbles.dart';

abstract class ScannerRemoteDataSource {
  //
  Future<PaperData> getPaperData({
    required Uint8List idImage,
    required Uint8List formImage,
    required List<Uint8List> answersImages,
    required PaperType type,
  });
  //
  Future<Paper> fetchPaper({
    required PaperData data,
    required PaperSettings settings,
  });
  //
  Future<Unit> uploadResults({
    required List<Paper> papers,
    required OuterTest outerTest,
  });
  //
  Future<Unit> deleteOuterTest({required String name});
  //
  Future<List<Result>> getOuterTests();
}

class ScannerRemoteDataSourceImpl implements ScannerRemoteDataSource {
  Future<AnswersData> getAnswerData({
    required List<Uint8List> answersImages,
    required PaperType type,
  }) async {
    //
    List<RowBubbles> rows = [];
    //
    switch (type) {
      case PaperType.A4:
        for (var image in answersImages) {
          rows.addAll(await ChannelsService.analyzeImage(
            image: image,
            rows: 25,
            columns: 6,
          ));
        }
      case PaperType.A5:
        for (int i = 0; i < answersImages.length; i++) {
          rows.addAll(await ChannelsService.analyzeImage(
            image: answersImages[i],
            rows: i == 2 ? 16 : 17,
            columns: 6,
          ));
        }
      case PaperType.A6:
        for (int i = 0; i < answersImages.length; i++) {
          rows.addAll(await ChannelsService.analyzeImage(
            image: answersImages[i],
            rows: i == 1 ? 17 : 13,
            columns: 6,
          ));
        }
    }
    //
    for (int i = 0; i < rows.length; i++) {
      rows[i].setSelected();
    }
    //
    return AnswersData(rows: rows);
  }

  Future<IdData> getIdData({required Uint8List idImage}) async {
    //
    List<RowBubbles> rows = [];
    //
    rows = await ChannelsService.analyzeImage(
      image: idImage,
      rows: 10,
      columns: 7,
    );
    //
    for (int i = 0; i < rows.length; i++) {
      rows[i].setSelected(removeFirst: false);
    }
    //
    return IdData(rows: rows);
  }

  Future<FormData> getFormData({required Uint8List formImage}) async {
    //
    List<RowBubbles> rows = [];
    //
    rows = await ChannelsService.analyzeImage(
      image: formImage,
      rows: 1,
      columns: 4,
    );
    //
    for (int i = 0; i < rows.length; i++) {
      rows[i].setSelected(removeFirst: false);
    }
    //
    return FormData(row: rows.first);
  }

  @override
  Future<PaperData> getPaperData({
    required Uint8List idImage,
    required Uint8List formImage,
    required List<Uint8List> answersImages,
    required PaperType type,
  }) async {
    final id = await getIdData(
      idImage: idImage,
    );
    final answers = await getAnswerData(
      answersImages: answersImages,
      type: type,
    );
    //
    final form = await getFormData(formImage: formImage);
    //
    return PaperData(id: id, answers: answers, form: form);
  }

  @override
  Future<Paper> fetchPaper({
    required PaperData data,
    required PaperSettings settings,
  }) async {
    //
    Paper paper = Paper(
      data: data,
      settings: settings,
    );
    // get user id
    String userId = paper.data.id.userId;
    //
    final id = await locator<GetUserDataUC>().call(
      id: userId,
      isUuid: false,
    );
    //
    if (id.isLeft()) {
      throw Exception("لم يتم العثور على الطالب");
    }
    //
    id.fold(
      (l) {},
      (r) {
        paper = paper.copyWith(student: r);
      },
    );
    //
    return paper;
  }

  @override
  Future<Unit> uploadResults({
    required List<Paper> papers,
    required OuterTest outerTest,
  }) async {
    //
    List<Map> results = [];
    //
    for (var paper in papers) {
      results.add(
        ResultModel.fromClass(Result(
          id: 0,
          userId: paper.student!.uuid,
          userNumber: paper.student!.id,
          testId: null,
          bankId: null,
          outerTestId: outerTest.id,
          form: paper.data.form.row.selected!,
          mark: paper.getMark(),
          answers: paper.data.answers.rows.map((e) => e.selected).toList().sublist(0, outerTest.information.length),
          wrongAnswers: paper.getWrongSelections(),
          date: paper.settings.date,
          period: 0,
          testName: paper.settings.title,
          userName: paper.student!.name,
          teacherEmail: locator<TeacherData>().email,
        )).toJson(),
      );
    }
    //
    await Supabase.instance.client.from("results").insert(results);
    //
    return unit;
  }

  @override
  Future<Unit> deleteOuterTest({required String name}) async {
    await Supabase.instance.client.from("results").delete().eq("teacher_email", locator<TeacherData>().email).eq("test_name", name).isFilter("bank_id", null).isFilter("test_id", null);
    return unit;
  }

  @override
  Future<List<Result>> getOuterTests() async {
    //
    //
    List<Result> results = [];
    //
    final res = await Supabase.instance.client.from("results").select().eq("teacher_email", locator<TeacherData>().email).isFilter("bank_id", null).isFilter("test_id", null);
    //
    results = res.map((e) {
      return ResultModel.fromJson(e);
    }).toList();
    //
    return results;
  }
}
