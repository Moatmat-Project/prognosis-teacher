import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Presentation/notifications/state/send_notification_bloc/send_notification_bloc.dart';
import 'package:moatmat_teacher/Presentation/notifications/widgets/send_bulk_notification_body.dart';

class SendBulkNotificationView extends StatefulWidget {
  const SendBulkNotificationView({super.key, required this.usersData});
  final List<UserData> usersData;

  @override
  State<SendBulkNotificationView> createState() => _SendBulkNotificationViewState();
}

class _SendBulkNotificationViewState extends State<SendBulkNotificationView> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void _sendNotification(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    final notification = AppNotification(
      id: DateTime.now().millisecond.toString(),
      date: DateTime.now(),
      title: title,
      body: body,
    );

    context.read<SendNotificationBloc>().add(
          SendNotificationToUsers(
            imageFile: null,
            userIds: widget.usersData.map((e) => e.uuid).toList(),
            notification: notification,
          ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleSuccess() {
    _showSnackbar('تم إرسال الإشعار بنجاح');
    setState(() {
      titleController.clear();
      bodyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إرسال إشعار')),
      body: BlocListener<SendNotificationBloc, SendNotificationState>(
        listener: (context, state) {
          if (state is SendNotificationSuccess) {
            _handleSuccess();
          } else if (state is SendNotificationFailure) {
            _showSnackbar(state.message);
          }
        },
        child: SendBulkNotificationBody(
          formKey: _formKey,
          titleController: titleController,
          bodyController: bodyController,
          onSend: () => _sendNotification(context),
        ),
      ),
    );
  }
}
