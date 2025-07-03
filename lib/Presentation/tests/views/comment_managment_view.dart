import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/reply_comment.dart';
import 'package:moatmat_teacher/Presentation/tests/state/comment_managment/comments_managment_bloc.dart';

class CommentsManagmentView extends StatefulWidget {
  const CommentsManagmentView({super.key, required this.videoId});
  final int videoId;

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
      appBar: AppBar(
        title: Text('إدارة التعليقات والردود'),
      ),
      body: BlocBuilder<CommentsManagmentBloc, CommentsManagmentState>(
        builder: (context, state) {
          if (state.isLoadingComments) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.errorMsg != null) {
            return Center(child: Text('خطأ: ${state.errorMsg}'));
          }
          final comments = state.comments ?? [];

          if (comments.isEmpty) {
            return Center(child: Text('لا توجد تعليقات'));
          }

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final Comment comment = comments[index];
              final replies = state.repliesMap[comment.id] ?? [];

              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comment.username),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDeleteComment(context, comment.id);
                      },
                    ),
                  ],
                ),
                subtitle: Text(comment.comment),
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
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmDeleteReply(context, comment.id, reply.id);
                                },
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
              );
            },
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
}
