import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'package:moatmat_teacher/Features/scanner/domain/repository/scanner_repo.dart';

class FetchPaperUC {
  final ScannerRepository repository;

  FetchPaperUC({required this.repository});

  Future<Either<Exception, Paper>> call({
    required PaperData data,
    required PaperSettings settings,
  }) async {
    return repository.fetchPaper(
      data: data,
      settings: settings,
    );
  }
}
