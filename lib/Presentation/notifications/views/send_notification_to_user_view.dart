import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';
import 'package:moatmat_teacher/Presentation/notifications/widgets/send_bulk_notification_body.dart';

class SendNotificationToUserView extends StatefulWidget {
  const SendNotificationToUserView({super.key, required this.userData});
  final UserData userData;

  @override
  State<SendNotificationToUserView> createState() =>
      _SendNotificationToUserViewState();
}

class _SendNotificationToUserViewState
    extends State<SendNotificationToUserView> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void _sendNotification() {
    if (_formKey.currentState?.validate() ?? false) {
      final notification = AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
          date: DateTime.now(),
          );
      context.read<SendNotificationBloc>().add(
            SendNotificationToUsers(
              imageFile: null,
              userIds: [widget.userData.uuid],
              notification: notification,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إرسال إشعار إلى ${widget.userData.name}')),
      body: BlocListener<SendNotificationBloc, SendNotificationState>(
        listener: (context, state) {
          if (state is SendNotificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إرسال الإشعار بنجاح')),
            );
            Navigator.of(context).pop();
          } else if (state is SendNotificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SendBulkNotificationBody(
          formKey: _formKey,
          titleController: titleController,
          bodyController: bodyController,
          onSend: _sendNotification,
        ),
      ),
    );
  }
}
