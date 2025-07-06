import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.comment,
    required super.username,
    required super.userId,
    required super.likes,
    required super.videoId,
    required super.repliesNum,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map json) {
    return CommentModel(
      id: json["id"],
      videoId: json["video_id"],
      comment: json["comment_text"],
      likes: json["likes"],
      username: json["user_name"],
      userId: json["user_id"],
      repliesNum: json["replies_num"],
      createdAt: json["created_at"],
    );
  }
  factory CommentModel.fromClass(Comment comment) {
    return CommentModel(
      id: comment.id,
      comment: comment.comment,
      username: comment.username,
      userId: comment.userId,
      likes: comment.likes,
      videoId: comment.videoId,
      repliesNum: comment.repliesNum,
      createdAt: comment.createdAt,
    );
  }
  toJson({bool addId = false}) {
    return {
      if (addId) "id": id,
      "comment_text": comment,
      "user_id": userId,
      "video_id": videoId,
    };
  }
}
