import 'package:moatmat_teacher/Features/scanner/domain/entities/bubble.dart';

class BubbleModel extends Bubble {
  BubbleModel({
    required super.count,
    required super.image,
  });

  factory BubbleModel.fromJson(Map json) {
    return BubbleModel(
      count: json['count'],
      image: json['image'],
    );
  }
  factory BubbleModel.fromClass(Bubble bubble) {
    return BubbleModel(
      count: bubble.count,
      image: bubble.image,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "count": count,
      "image": image,
    };
  }
}
