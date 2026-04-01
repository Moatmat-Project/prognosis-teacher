import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';

class BankInformation {
  final String title; //
  final String classs; //
  final String material;
  final String teacher;
  final int price; //
  final List<String>? images;
  final String? schoolId;
  final String? collegeId;

  final List<Video>? videos;
  final List<String>? files;

  BankInformation({
    required this.schoolId,
    this.collegeId,
    required this.title,
    required this.classs,
    required this.material,
    required this.teacher,
    required this.images,
    required this.price,
    required this.videos,
    required this.files,
  });
  BankInformation copyWith({
    String? title,
    String? classs,
    String? material,
    String? teacher,
    int? price,
    String? password,
    int? period,
    List<Video>? videos,
    List<String>? images,
    List<String>? files,
    String? schoolId,
    String? collegeId,
  }) {
    return BankInformation(
      title: title ?? this.title,
      schoolId: schoolId ?? this.schoolId,
      collegeId: collegeId ?? this.collegeId,
      classs: classs ?? this.classs,
      material: material ?? this.material,
      teacher: teacher ?? this.teacher,
      price: price ?? this.price,
      videos: videos ?? this.videos,
      images: images ?? this.images,
      files: files ?? this.files,
    );
  }
}
