import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/reply_comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/delete_comment_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/delete_reply_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_comment_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_replies_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_video_uc.dart';

part 'comments_managment_event.dart';
part 'comments_managment_state.dart';

class CommentsManagmentBloc extends Bloc<CommentsManagmentEvent, CommentsManagmentState> {
  CommentsManagmentBloc() : super(CommentsManagmentState()) {
    on<LoadComments>(_onLoadComments);
    on<LoadVideo>(_onLoadVideo);
    on<LoadReplies>(_onLoadReplies);
    on<DeleteComment>(_onDeleteComment);
    on<DeleteReply>(_onDeleteReply);
  }

  Future<void> _onLoadComments(LoadComments event, Emitter<CommentsManagmentState> emit) async {
    emit(state.copyWith(isLoadingComments: true, errorMsg: null));
    final res = await locator<GetCommentUc>().call(videoId: event.videoId);
    res.fold(
      (l) => emit(state.copyWith(isLoadingComments: false, errorMsg: l.toString())),
      (r) => emit(state.copyWith(isLoadingComments: false, comments: r, errorMsg: null)),
    );
  }

  Future<void> _onLoadVideo(LoadVideo event, Emitter<CommentsManagmentState> emit) async {
    emit(state.copyWith(isLoadingUrl: true, errorMsg: null));
    final res = await locator<GetVideoUc>().call(videoId: event.videoId);
    res.fold(
      (l) => emit(state.copyWith(isLoadingUrl: false, errorMsg: l.toString())),
      (r) => emit(state.copyWith(isLoadingUrl: false,url: r, errorMsg: r == "" ? "video not exist" :null)),
    );
  }

  Future<void> _onLoadReplies(LoadReplies event, Emitter<CommentsManagmentState> emit) async {
    emit(state.copyWith(loadingRepliesForComments: {...state.loadingRepliesForComments, event.commentId}));
    final res = await locator<GetRepliesUc>().call(commentId: event.commentId);
    res.fold(
      (l) => emit(state.copyWith(
        errorMsg: l.toString(),
        loadingRepliesForComments: state.loadingRepliesForComments..remove(event.commentId),
      )),
      (r) => emit(state.copyWith(
        repliesMap: {...state.repliesMap, event.commentId: r},
        loadingRepliesForComments: state.loadingRepliesForComments..remove(event.commentId),
      )),
    );
  }

  Future<void> _onDeleteComment(DeleteComment event, Emitter<CommentsManagmentState> emit) async {
    emit(state.copyWith(isDeleting: true));
    final res = await locator<DeleteCommentUc>().call(commentId: event.commentId);
    res.fold(
      (l) => emit(state.copyWith(isDeleting: false, errorMsg: l.toString())),
      (r) {
        final updatedComments = state.comments?.where((c) => c.id != event.commentId).toList();
        emit(state.copyWith(comments: updatedComments, isDeleting: false));
      },
    );
  }

  Future<void> _onDeleteReply(DeleteReply event, Emitter<CommentsManagmentState> emit) async {
    emit(state.copyWith(isDeleting: true));
    //
    final res = await locator<DeleteReplyUc>().call(replyId: event.replyId);
   // 
    res.fold(
      (l) => emit(state.copyWith(isDeleting: false, errorMsg: l.toString())),
      (r) {
        //
        final updatedReplies = state.repliesMap[event.commentId]
            ?.where((rep) => rep.id != event.replyId)
            .toList();
        //
        final updatedMap = {
          ...state.repliesMap,
          event.commentId: updatedReplies ?? [],
        };
        //
        final updatedComments = state.comments?.map((comment) {
          if (comment.id == event.commentId) {
            return comment.copyWith(
              repliesNum: (comment.repliesNum - 1).clamp(0, double.infinity).toInt(),
            );
          }
          return comment;
        }).toList();

        emit(state.copyWith(
          repliesMap: updatedMap,
          comments: updatedComments,
          isDeleting: false,
        ));
      },
    );
  }
}
