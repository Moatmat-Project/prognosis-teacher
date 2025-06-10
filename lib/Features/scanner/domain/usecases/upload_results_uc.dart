import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'package:moatmat_teacher/Features/scanner/domain/repository/scanner_repo.dart';

import '../../../outer_tests/domain/entities/outer_test.dart';

class UploadResultsUC {
  final ScannerRepository repository;

  UploadResultsUC({required this.repository});

  Future<Either<Exception, Unit>> call({required List<Paper> papers, required OuterTest outerTest,}) async {
    return repository.uploadResults(papers: papers, outerTest: outerTest);
  }
}
