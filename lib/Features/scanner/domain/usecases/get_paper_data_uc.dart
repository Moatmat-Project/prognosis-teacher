import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'package:moatmat_teacher/Features/scanner/domain/repository/scanner_repo.dart';

class GetPaperDataUC {
  final ScannerRepository repository;

  GetPaperDataUC({required this.repository});

  Future<Either<Exception, PaperData>> call({
    required Uint8List idImage,
    required Uint8List formImage,
    required List<Uint8List> answersImages,
    required PaperType type,
  }) async {
    return repository.getPaperData(
      idImage: idImage,
      formImage: formImage,
      answersImages: answersImages,
      type: type,
    );
  }
}
