import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Features/scanner/data/datasources/scanner_remote_ds.dart';
import 'package:moatmat_teacher/Features/scanner/domain/repository/scanner_repo.dart';

import '../../../outer_tests/domain/entities/outer_test.dart';
import '../../../students/domain/entities/result.dart';
import '../../domain/entities/paper.dart';

class ScannerRepositoryImpl implements ScannerRepository {
  final ScannerRemoteDataSource dataSource;

  ScannerRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Exception, PaperData>> getPaperData({
    required Uint8List idImage,
    required List<Uint8List> answersImages,
    required Uint8List formImage,
    required PaperType type,
  }) async {
    try {
      final res = await dataSource.getPaperData(
        idImage: idImage,
        answersImages: answersImages,
        type: type,
        formImage: formImage,
      );
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Paper>> fetchPaper({
    required PaperData data,
    required PaperSettings settings,
  }) async {
    try {
      final paper = await dataSource.fetchPaper(data: data, settings: settings);
      return right(paper);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> uploadResults({
    required OuterTest outerTest,
    required List<Paper> papers,
  }) async {
    try {
      final res = await dataSource.uploadResults(papers: papers, outerTest: outerTest);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteOuterTest({
    required String name,
  }) async {
    try {
      final res = await dataSource.deleteOuterTest(name: name);
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, List<Result>>> getOuterTests() async {
    try {
      final res = await dataSource.getOuterTests();
      return right(res);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
