part of 'comments_managment_bloc.dart';

class CommentsManagmentState extends Equatable {
  final List<Comment>? comments;
  final Map<int, List<ReplyComment>> repliesMap;
  final Set<int> loadingRepliesForComments;
  final bool isLoadingComments;
  final bool isDeleting;
  final String? errorMsg;

  const CommentsManagmentState({
    this.comments,
    this.repliesMap = const {},
    this.loadingRepliesForComments = const {},
    this.isLoadingComments = false,
    this.isDeleting = false,
    this.errorMsg,
  });

  CommentsManagmentState copyWith({
    List<Comment>? comments,
    Map<int, List<ReplyComment>>? repliesMap,
    Set<int>? loadingRepliesForComments,
    bool? isLoadingComments,
    bool? isDeleting,
    String? errorMsg,
  }) {
    return CommentsManagmentState(
      comments: comments ?? this.comments,
      repliesMap: repliesMap ?? this.repliesMap,
      loadingRepliesForComments: loadingRepliesForComments ?? this.loadingRepliesForComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMsg: errorMsg,
    );
  }

  @override
  List<Object?> get props => [comments, repliesMap, loadingRepliesForComments, isLoadingComments, isDeleting, errorMsg];
}
