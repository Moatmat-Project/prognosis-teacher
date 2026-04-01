import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';

class CollegeModel extends College {
  CollegeModel({
    required super.id,
    required super.name,
    super.description,
    super.imageUrl,
    required super.schoolId,
  });

  factory CollegeModel.fromJson(Map<String, dynamic> json) {
    return CollegeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      schoolId: json['school_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'school_id': schoolId,
    };
  }
}
