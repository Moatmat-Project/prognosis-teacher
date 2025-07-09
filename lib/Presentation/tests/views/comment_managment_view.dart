import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/reply_comment.dart';
import 'package:moatmat_teacher/Presentation/tests/state/comment_managment/comments_managment_bloc.dart';
import 'package:moatmat_teacher/Presentation/tests/widgets/video_player_w.dart';

class CommentsManagmentView extends StatefulWidget {
  const CommentsManagmentView({
    super.key,
    required this.videoId,
    required this.url,
    this.commentId,
  });
  final int videoId;
  final String url;
  final int? commentId;
  @override
  State<CommentsManagmentView> createState() => _CommentsManagmentViewState();
}

class _CommentsManagmentViewState extends State<CommentsManagmentView> {
  @override
  void initState() {
    super.initState();
    context.read<CommentsManagmentBloc>().add(LoadComments(videoId: widget.videoId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.background,
      appBar: AppBar(
        title: Text('إدارة التعليقات والردود'),
        backgroundColor: ColorsResources.background,
      ),
      body: BlocBuilder<CommentsManagmentBloc, CommentsManagmentState>(
        builder: (context, state) {
          //
          if (state.isLoadingComments) {
            return Center(child: CircularProgressIndicator());
          }
          //
          if (state.errorMsg != null) {
            return Center(child: Text('خطأ: ${state.errorMsg}'));
          }
          //
          final comments = state.comments ?? [];
          //
          if (comments.isEmpty) {
            return Center(child: Text('لا توجد تعليقات'));
          }
          //
          Comment? specificComment;
          if (widget.commentId != null) {
            try {
              specificComment = comments.firstWhere((c) => c.id == widget.commentId);
            } catch (_) {}
          }
          //
          return Column(
            children: [
              Column(
                children: [
                  // video player
                  ChewiePlayerWidget(videoUrl: widget.url),
                  //
                  Padding(padding: EdgeInsets.only(top: SizesResources.s3)),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: comments.length + (specificComment != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    //
                    if (index == 0 && specificComment != null) {
                      return _buildCommentCard(context, specificComment, state,isHighlighted:  true);
                    }
                    //
                    final actualIndex = specificComment != null ? index - 1 : index;
                    //
                    final comment = comments[actualIndex];
                    //
                    if (comment.id == widget.commentId) return SizedBox.shrink();
                    //
                    return _buildCommentCard(context, comment, state);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(padding: EdgeInsets.only(top: SizesResources.s1));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteComment(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل تريد حذف هذا التعليق؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          TextButton(
            onPressed: () {
              context.read<CommentsManagmentBloc>().add(DeleteComment(commentId: commentId));
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteReply(BuildContext context, int commentId, int replyId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل تريد حذف هذا الرد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          TextButton(
            onPressed: () {
              context.read<CommentsManagmentBloc>().add(DeleteReply(commentId: commentId, replyId: replyId));
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(BuildContext context, Comment comment, CommentsManagmentState state, {bool isHighlighted = false}) {
    final replies = state.repliesMap[comment.id] ?? [];

    return Card(
      elevation: isHighlighted ? 4 : 1,
      color: isHighlighted ? ColorsResources.onPrimary.withOpacity(0.95) : ColorsResources.onPrimary,
      shape: RoundedRectangleBorder(
        side: isHighlighted
            ? BorderSide(color: Colors.blueAccent, width: 1.5)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ExpansionTile(
          initiallyExpanded: isHighlighted,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isHighlighted)
                    Icon(Icons.push_pin, size: 18, color: Colors.blueAccent),
                  if (isHighlighted) SizedBox(width: 6),
                  Text(comment.username),
                ],
              ),
              TextButton(
                onPressed: () => _confirmDeleteComment(context, comment.id),
                child: Text('حذف'),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment.comment),
              if (isHighlighted)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'تعليق محدد',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 12),
                  ),
                ),
            ],
          ),
          children: [
            if (state.loadingRepliesForComments.contains(comment.id))
              Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              )
            else
              Column(
                children: replies.map((ReplyComment reply) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(reply.username),
                        TextButton(
                          onPressed: () => _confirmDeleteReply(context, comment.id, reply.id),
                          child: Text('حذف'),
                        ),
                      ],
                    ),
                    subtitle: Text(reply.comment),
                  );
                }).toList(),
              ),
            TextButton(
              onPressed: () {
                context.read<CommentsManagmentBloc>().add(LoadReplies(commentId: comment.id));
              },
              child: Text('تحميل الردود (${comment.repliesNum})'),
            ),
          ],
        ),
      ),
    );
  }

}
