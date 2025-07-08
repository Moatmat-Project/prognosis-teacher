import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';

class VideoModel extends Video {
  VideoModel({
    required super.id,
    required super.url,
    required super.teacherId,
  });

  factory VideoModel.fromJson(Map json) {
    return VideoModel(
      id: json["id"] ?? 0,
      url: json["url"],
      teacherId : json["teacher_id"] ?? "-",
    );
  }
  factory VideoModel.fromClass(Video video) {
    return VideoModel(
      id: video.id,
      url: video.url,
      teacherId: video.teacherId,
    );
  }
  Video toClass() {
    return Video(
      id: id,
      url: url,
      teacherId: teacherId,
    );
  }

  factory VideoModel.fromUrl(String url) {
    return VideoModel(
      id: -1,
      url: url,
      teacherId : "",
    );
  }
  toJson({
    bool addId = false,
  }) {
    return {
      if (addId) "id": id,
      "url": url,
      "teacher_id": teacherId,
    };
  }
}
