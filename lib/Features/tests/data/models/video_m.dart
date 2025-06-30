import 'package:moatmat_teacher/Features/tests/domain/entities/video.dart';

class VideoModel extends Video {
  VideoModel({
    required super.id,
    required super.url,
  });

  factory VideoModel.fromJson(Map json) {
    return VideoModel(
      id: json["id"],
      url: json["url"],
    );
  }
  factory VideoModel.fromClass(Video video) {
    return VideoModel(
      id: video.id,
      url: video.url,
    );
  }
  factory VideoModel.fromUrl(String url) {
    return VideoModel(
      id: -1,
      url: url,
    );
  }
  toJson({bool addId = false,}) {
    return {
      if (addId) "id": id,
      "url" : url,
    };
  }
}
