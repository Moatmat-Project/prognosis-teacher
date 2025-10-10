import 'package:moatmat_teacher/Features/banks/domain/entities/bank_information.dart';
import 'package:moatmat_teacher/Features/tests/data/models/video_m.dart';

class BankInformationModel extends BankInformation {
  BankInformationModel({
    required super.title,
    required super.classs,
    required super.material,
    required super.teacher,
    required super.price,
    required super.videos,
    required super.images,
    required super.files,
    required super.schoolId,
  });

  factory BankInformationModel.fromJson(Map json) {
    return BankInformationModel(
      title: json["title"],
      classs: "classs",
      material: "material",
      teacher: json["teacher"],
      price: json["price"],
      schoolId: json["school_id"]?.toString(),
      images: (json["images"] ?? []).cast<String>(),
      videos: (json["videos"] as List?)?.map((e) => VideoModel.fromJson(e)).toList(),
      files: List.generate(
        (json["files"] as List? ?? []).length,
        (i) => json["files"][i],
      ),
    );
  }

  static List<String> stringToList(String? value) {
    try {
      if (value == null || value == '') {
        return [];
      } else {
        return value.split(',');
      }
    } on Exception {
      return [];
    }
  }

  factory BankInformationModel.fromClass(BankInformation information) {
    return BankInformationModel(
      title: information.title,
      classs: "classs",
      material: "material",
      teacher: information.teacher,
      price: information.price,
      schoolId: information.schoolId,
      videos: information.videos,
      images: information.images,
      files: information.files,
    );
  }

  toJson() {
    return {
      "title": title,
      "classs": "classs",
      "material": "material",
      "teacher": teacher,
      "price": price,
      "videos": (videos?.isNotEmpty ?? false) ? videos?.map((e) => VideoModel.fromClass(e).toJson()).toList() : [],
      "images": images,
      "files": files,
      "school_id": schoolId,
    };
  }
}
