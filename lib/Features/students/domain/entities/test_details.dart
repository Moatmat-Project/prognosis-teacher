import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';

class RepositoryDetails {
  final double averageMark;
  final double averageTime;
  final Map<int, int> marksData;
  final List<List<double>> selectionPercents;
  final List<(Result, double)> marks;

  RepositoryDetails({
    required this.marksData,
    required this.averageMark,
    required this.averageTime,
    required this.selectionPercents,
    required this.marks,
  });

  getMarkPercentage(double mark) {
    //
    int key = mark.toInt();
    //
    if (marksData[key] != null) {
      //
      int count = marksData[key]!;
      //
      double percentage = count / marks.length;
      //
      return percentage;
      //
    } else {
      return 0.0;
    }
  }
}
