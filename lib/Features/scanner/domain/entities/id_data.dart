import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/row_bubbles.dart';

class IdData {
  //
  List<RowBubbles> rows;
  //
  IdData({
    required this.rows,
  }) {
    //
    if (rows.length == 7) return;
    //
    List<RowBubbles> idRows = List.filled(7, RowBubbles(bubbles: []));
    //
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 7; j++) {
        idRows[j] = idRows[j].copyWith(
          bubbles: idRows[j].bubbles + [rows[i].bubbles[j]],
        );
        idRows[j].setSelected(removeFirst: false);
      }
    }
    rows = idRows;
  }
  //
  String get userId {
    //
    String id = "";
    //
    for (int i = 1; i < rows.length; i++) {
      id += (rows[i].selected ?? 0).toString();
    }
    //
    debugPrint("user id is $id");
    //
    return id;
  }
}
