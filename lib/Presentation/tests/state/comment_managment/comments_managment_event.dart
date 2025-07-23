part of 'comments_managment_bloc.dart';

sealed class CommentsManagmentEvent extends Equatable {
  const CommentsManagmentEvent();
  @override
  List<Object> get props => [];
}

class LoadComments extends CommentsManagmentEvent {
  final int videoId;
  const LoadComments({required this.videoId});
}

class GetTestTitle extends CommentsManagmentEvent {
  final int testId;
  const GetTestTitle({required this.testId});
}

class LoadVideo extends CommentsManagmentEvent {
  final int videoId;
  const LoadVideo({required this.videoId});
}

class LoadReplies extends CommentsManagmentEvent {
  final int commentId;
  const LoadReplies({required this.commentId});
}

class DeleteComment extends CommentsManagmentEvent {
  final int commentId;
  const DeleteComment({required this.commentId});
}

class DeleteReply extends CommentsManagmentEvent {
  final int replyId;
  final int commentId;
  const DeleteReply({required this.replyId, required this.commentId});
}
