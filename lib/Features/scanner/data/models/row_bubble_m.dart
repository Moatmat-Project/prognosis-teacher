import 'package:moatmat_teacher/Features/scanner/data/models/bubble_m.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/row_bubbles.dart';

class RowBubblesModel extends RowBubbles {
  RowBubblesModel({required super.bubbles});
  //
  Map<String, dynamic> toJson() {
    return {
      "bubbles": bubbles.map((bubble) {
        return BubbleModel.fromClass(bubble).toJson();
      }).toList(),
    };
  }

  //
  factory RowBubblesModel.fromJson(Map<String, dynamic> json) {
    return RowBubblesModel(
      bubbles: (json['bubbles'] as List).map((bubbleJson) {
        return BubbleModel.fromJson(bubbleJson);
      }).toList(),
    );
  }
  factory RowBubblesModel.fromClass(RowBubbles row) {
    return RowBubblesModel(
      bubbles: row.bubbles,
    );
  }
}
