import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';

import '../../../outer_tests/domain/entities/outer_test.dart';
import '../../../students/domain/entities/result.dart';

abstract class ScannerRepository {
  //
  Future<Either<Exception, PaperData>> getPaperData({
    required Uint8List idImage,
    required Uint8List formImage,
    required List<Uint8List> answersImages,
    required PaperType type,
  });
  //
  Future<Either<Exception, Paper>> fetchPaper({
    required PaperData data,
    required PaperSettings settings,
  });
  //
  Future<Either<Exception, Unit>> uploadResults({
    required OuterTest outerTest,
    required List<Paper> papers,
  });
  //
  Future<Either<Exception, List<Result>>> getOuterTests();
  //
  Future<Either<Exception, Unit>> deleteOuterTest({required String name});
  //
}
