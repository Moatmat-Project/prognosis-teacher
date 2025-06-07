import 'dart:typed_data';

class QuestionImageInformation {
  final Uint8List bytes;
  int height;
  int width;

  QuestionImageInformation._({
    required this.bytes,
    required this.height,
    required this.width,
  });

  factory QuestionImageInformation({
    required Uint8List bytes,
    required int originalHeight,
    required int originalWidth,
    required int itemWidth,
  }) {
    int calculatedWidth = itemWidth;
    final int calculatedHeight = (calculatedWidth * originalHeight) ~/ originalWidth;
    return QuestionImageInformation._(
      bytes: bytes,
      height: calculatedHeight,
      width: calculatedWidth,
    );
  }
  factory QuestionImageInformation.fromClass({
    required QuestionImageInformation image,
    required int newWidth,
  }) {
    int calculatedWidth = newWidth;
    final int calculatedHeight = (calculatedWidth * image.height) ~/ image.width;
    return QuestionImageInformation._(
      bytes: image.bytes,
      height: calculatedHeight,
      width: calculatedWidth,
    );
  }
}
