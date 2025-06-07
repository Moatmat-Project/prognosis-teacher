import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import '../../Features/scanner/data/models/bubble_m.dart';
import '../../Features/scanner/domain/entities/bubble.dart';
import '../../Features/scanner/domain/entities/paper.dart';
import '../../Features/scanner/domain/entities/row_bubbles.dart';

class ChannelsService {
  //
  static const methodChannel = MethodChannel('com.moatmat.teacher');
  //
  static Future<int> processImage(CameraImage image, PaperType type) async {
    //
    List<int> strides = Int32List(image.planes.length * 2);
    //
    int index = 0;
    //
    final bytes = image.planes.map((plane) {
      strides[index] = (plane.bytesPerRow);
      index++;
      strides[index] = (plane.bytesPerPixel)!;
      index++;
      return plane.bytes;
    }).toList();
    //
    int methodType = 1;
    //
    switch (type) {
      case PaperType.A4:
        methodType = 4;
      case PaperType.A5:
        methodType = 5;
      case PaperType.A6:
        methodType = 6;
    }
    //
    final values = {
      'platforms': bytes,
      'height': image.height,
      'width': image.width,
      'strides': strides,
      'type': methodType,
    };
    //
    var res = await methodChannel.invokeMethod(
      "process_image",
      values,
    );
    //
    return res as int;
  }

  static Future<List<RowBubbles>> analyzeImage({
    required Uint8List image,
    required int rows,
    required int columns,
  }) async {
    //
    image = await rotateImage(image, 90);
    //
    final values = {
      'image': image,
      'columns': columns,
      'rows': rows,
    };
    //
    final List<dynamic> res = await methodChannel.invokeMethod(
      'analyze_image',
      values,
    );
    //
    List<List<Map<String, dynamic>>> mappedImages = [];
    //
    mappedImages = res.map<List<Map<String, dynamic>>>((row) {
      return (row as List<dynamic>).map<Map<String, dynamic>>((item) {
        return {
          'image': Uint8List.fromList(item['image']),
          'count': item['count'],
        };
      }).toList();
    }).toList();
    //
    List<RowBubbles> rowsBubbles = [];
    //
    for (var rowMap in mappedImages) {
      List<Bubble> bubbles = [];
      for (var map in rowMap) {
        bubbles.add(BubbleModel.fromJson(map));
      }
      rowsBubbles.add(RowBubbles(bubbles: bubbles));
    }
    //
    return rowsBubbles;
  }

  static Future<List<Uint8List>> extractImages(
    Uint8List bytes,
    PaperType type,
  ) async {
    //
    bytes = await rotateImage(bytes, -90);
    //
    int paperType = 4;
    //
    switch (type) {
      case PaperType.A4:
        paperType = 4;
      case PaperType.A5:
        paperType = 5;
      case PaperType.A6:
        paperType = 6;
    }
    //
    final values = {
      'image': bytes,
      'type': paperType,
    };
    //
    // Invoke the native method and expect a list in return
    final res = await methodChannel.invokeMethod<List<Object?>>(
      'extract_images',
      values,
    );
    // Cast the response back to a list of Uint8List and return
    return (res ?? []).cast<Uint8List>();
    //
  }

  static Future<Uint8List> rotateImage(
    Uint8List imageData,
    double angleInDegrees,
  ) async {
    // Decode Uint8List image data into Image object
    img.Image image = img.decodeImage(imageData)!;

    // Rotate the image by angleInDegrees
    img.Image rotatedImage = img.copyRotate(
      image,
      angle: angleInDegrees.toInt(),
    );

    // Encode rotated image back to Uint8List
    Uint8List rotatedImageData = Uint8List.fromList(
      img.encodePng(rotatedImage),
    );

    return rotatedImageData;
  }
}
