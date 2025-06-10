import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/bubble.dart';

class RowBubbles {
  //
  int? selected;
  final List<Bubble> bubbles;
  //
  RowBubbles({
    required this.bubbles,
    this.selected,
  });
  //

  int? setSelected({bool removeFirst = true}) {
    //
    if (selected != null) return selected;
    //
    int sum = 0;
    //
    List<(int, int)> counts = [];
    //
    (int, int) biggest1 = (0, 0);
    (int, int) biggest2 = (0, 0);
    (int, int) smallest = (0, 0);
    //
    for (int i = 0; i < bubbles.length; i++) {
      //
      if (i == 0 && removeFirst) continue;
      //
      counts.add((i, bubbles[i].count));
      sum += bubbles[i].count;
      if (biggest1.$2 < bubbles[i].count) {
        biggest1 = (i, bubbles[i].count);
      }
      if (smallest.$2 > bubbles[i].count) {
        smallest = (i, bubbles[i].count);
      }
      //
    }
    for (int i = 0; i < bubbles.length; i++) {
      //
      if (i == 0 && removeFirst) continue;
      //
      if (biggest2.$2 < bubbles[i].count && i != biggest1.$1) {
        biggest2 = (i, bubbles[i].count);
      }
    }
    double firstPercent = biggest2.$2 / biggest1.$2;
    double secondPercent = (sum / bubbles.length) / biggest1.$2;
    double thirdPercent = smallest.$2 * 1.5;
    //
    bool con1, con2, con3, con4;
    //
    con1 = firstPercent < 0.75;
    con2 = secondPercent < 0.60;
    con3 = thirdPercent < biggest1.$2;
    con4 = biggest1.$2 > 100;
    //

    //
    if (con1 && con2 && con3 && con4) {
      print(
          "true $firstPercent . $secondPercent , $counts , b ${biggest1.$2} , ${biggest2.$2}}");
      selected = biggest1.$1;
      return biggest1.$1;
    }
    print(
        "false $firstPercent . $secondPercent , $counts , b ${biggest1.$2} , ${biggest2.$2}}");
    //
    selected = null;
    return null;
  }

  RowBubbles copyWith({
    int? selected,
    List<Bubble>? bubbles,
  }) {
    return RowBubbles(
      selected: selected ?? this.selected,
      bubbles: bubbles ?? this.bubbles,
    );
  }
}
