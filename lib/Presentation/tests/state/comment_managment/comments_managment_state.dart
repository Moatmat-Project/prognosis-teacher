part of 'comments_managment_bloc.dart';

class CommentsManagmentState extends Equatable {
  final List<Comment>? comments;
  final String? url;
  final Map<int, List<ReplyComment>> repliesMap;
  final Set<int> loadingRepliesForComments;
  final bool isLoadingComments;
  final bool isLoadingUrl;
  final bool isDeleting;
  final String? errorMsg;

  const CommentsManagmentState({
    this.comments,
    this.url,
    this.repliesMap = const {},
    this.loadingRepliesForComments = const {},
    this.isLoadingComments = false,
    this.isDeleting = false,
    this.isLoadingUrl = false,
    this.errorMsg,
  });

  CommentsManagmentState copyWith({
    List<Comment>? comments,
    String? url,
    Map<int, List<ReplyComment>>? repliesMap,
    Set<int>? loadingRepliesForComments,
    bool? isLoadingComments,
    bool? isLoadingUrl,
    bool? isDeleting,
    String? errorMsg,
  }) {
    return CommentsManagmentState(
      comments: comments ?? this.comments,
      url: url ?? this.url,
      repliesMap: repliesMap ?? this.repliesMap,
      loadingRepliesForComments: loadingRepliesForComments ?? this.loadingRepliesForComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isDeleting: isDeleting ?? this.isDeleting,
      isLoadingUrl: isLoadingUrl ?? this.isLoadingUrl,
      errorMsg: errorMsg,
    );
  }

  @override
  List<Object?> get props => [comments, url, repliesMap, loadingRepliesForComments, isLoadingComments, isLoadingUrl, isDeleting, errorMsg];
}
