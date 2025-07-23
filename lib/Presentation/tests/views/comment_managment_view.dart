import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/comment.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/reply_comment.dart';
import 'package:moatmat_teacher/Presentation/tests/state/comment_managment/comments_managment_bloc.dart';
import 'package:moatmat_teacher/Presentation/tests/widgets/chewie_player_widget.dart';

class CommentsManagmentView extends StatefulWidget {
  const CommentsManagmentView({
    super.key,
    required this.videoId,
    required this.testId,
    this.commentId,
  });
  final int videoId;
  final int? commentId;
  final int? testId;
  @override
  State<CommentsManagmentView> createState() => _CommentsManagmentViewState();
}

class _CommentsManagmentViewState extends State<CommentsManagmentView> {
  @override
  void initState() {
    super.initState();
    if (widget.testId != null) context.read<CommentsManagmentBloc>().add(GetTestTitle(testId: widget.testId!));
    context.read<CommentsManagmentBloc>().add(LoadVideo(videoId: widget.videoId));
    context.read<CommentsManagmentBloc>().add(LoadComments(videoId: widget.videoId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsManagmentBloc, CommentsManagmentState>(
      builder: (context, state) {
        //
        if (state.isLoadingComments) {
          return Scaffold(
            backgroundColor: ColorsResources.background,
            appBar: AppBar(
              title: Text(state.testTitle ?? 'إدارة التعليقات والردود'),
              backgroundColor: ColorsResources.background,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        //
        if (state.errorMsg != null) {
          return Scaffold(
            backgroundColor: ColorsResources.background,
            appBar: AppBar(
              title: Text(state.testTitle ?? 'إدارة التعليقات والردود'),
              backgroundColor: ColorsResources.background,
            ),
            body: Center(child: Text('خطأ: ${state.errorMsg}')),
          );
        }
        //
        final comments = state.comments ?? [];
        //
        if (comments.isEmpty) {
          return Scaffold(
            backgroundColor: ColorsResources.background,
            appBar: AppBar(
              title: Text(state.testTitle ?? 'إدارة التعليقات والردود'),
              backgroundColor: ColorsResources.background,
            ),
            body: Column(
              children: [
                // video player
                ChewiePlayerWidget(videoUrl: state.url ?? ""),
                //
                Padding(padding: EdgeInsets.only(top: SizesResources.s3)),
                //
                Center(child: Text('لا توجد تعليقات')),
              ],
            ),
          );
        }
        //
        Comment? specificComment;
        if (widget.commentId != null) {
          try {
            specificComment = comments.firstWhere((c) => c.id == widget.commentId);
          } catch (_) {}
        }
        //
        return Scaffold(
          backgroundColor: ColorsResources.background,
          appBar: AppBar(
            title: Text(state.testTitle ?? 'إدارة التعليقات والردود'),
            backgroundColor: ColorsResources.background,
          ),
          body: Column(
            children: [
              Column(
                children: [
                  // video player
                  ChewiePlayerWidget(videoUrl: state.url ?? ""),
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
                      return _buildCommentCard(context, specificComment, state, isHighlighted: true);
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
          ),
        );
      },
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

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizesResources.s3,
        vertical: SizesResources.s1,
      ),
      decoration: BoxDecoration(
        color: isHighlighted ? ColorsResources.primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? ColorsResources.primary.withOpacity(0.3) : ColorsResources.borders,
          width: isHighlighted ? 1.5 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsResources.primary.withOpacity(0.05),
            spreadRadius: 0.5,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header
          Container(
            padding: EdgeInsets.all(SizesResources.s3),
            decoration: BoxDecoration(
              color: isHighlighted ? ColorsResources.primary.withOpacity(0.1) : ColorsResources.background.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // User icon and highlight indicator
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isHighlighted ? ColorsResources.primary : ColorsResources.primary.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isHighlighted ? Icons.push_pin : Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: SizesResources.s2),

                // Username and highlight label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      if (isHighlighted)
                        Text(
                          'تعليق محدد',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorsResources.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),

                // Delete button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _confirmDeleteComment(context, comment.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizesResources.s2,
                        vertical: SizesResources.s1,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'حذف',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Comment content
          Padding(
            padding: EdgeInsets.all(SizesResources.s3),
            child: Text(
              comment.comment,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),

          // Replies section
          if (replies.isNotEmpty || state.loadingRepliesForComments.contains(comment.id))
            Container(
              margin: EdgeInsets.only(
                left: SizesResources.s4,
                right: SizesResources.s4,
                bottom: SizesResources.s2,
              ),
              padding: EdgeInsets.all(SizesResources.s2),
              decoration: BoxDecoration(
                color: ColorsResources.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorsResources.borders.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Replies header
                  Padding(
                    padding: EdgeInsets.only(bottom: SizesResources.s2),
                    child: Text(
                      'الردود (${comment.repliesNum})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorsResources.primary,
                      ),
                    ),
                  ),

                  // Loading indicator or replies list
                  if (state.loadingRepliesForComments.contains(comment.id))
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(SizesResources.s2),
                        child: CupertinoActivityIndicator(
                          color: ColorsResources.primary,
                        ),
                      ),
                    )
                  else
                    ...replies.map((ReplyComment reply) {
                      return Container(
                        margin: EdgeInsets.only(bottom: SizesResources.s1),
                        padding: EdgeInsets.all(SizesResources.s2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: ColorsResources.borders.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Reply user icon
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: ColorsResources.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.reply,
                                color: ColorsResources.primary,
                                size: 12,
                              ),
                            ),
                            SizedBox(width: SizesResources.s1),

                            // Reply content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reply.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    reply.comment,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delete reply button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap: () => _confirmDeleteReply(context, comment.id, reply.id),
                                child: Padding(
                                  padding: EdgeInsets.all(SizesResources.s1),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red.withOpacity(0.7),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),

          // Load replies button
          if (comment.repliesNum > 0)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                left: SizesResources.s3,
                right: SizesResources.s3,
                bottom: SizesResources.s3,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    context.read<CommentsManagmentBloc>().add(LoadReplies(commentId: comment.id));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: SizesResources.s2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorsResources.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        replies.isEmpty ? 'تحميل الردود (${comment.repliesNum})' : 'إعادة تحميل الردود',
                        style: TextStyle(
                          color: ColorsResources.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
