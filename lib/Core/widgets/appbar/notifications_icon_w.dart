import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Presentation/reports/state/reports/reports_cubit.dart';

import '../../../Presentation/notifications/views/notifications_view.dart';

class NotificationsIconWidget extends StatefulWidget {
  const NotificationsIconWidget({super.key});

  @override
  State<NotificationsIconWidget> createState() => _NotificationsIconWidgetState();
}

class _NotificationsIconWidgetState extends State<NotificationsIconWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotificationsView(),
          ),
        );
      },
      icon: Stack(
        children: [
          // report icon
          const Icon(
            Icons.notifications,
          ),
          Opacity(
            opacity: 0,
            // opacity: (state is ReportsInitial && state.newReports) ? 1 : 0,
            child: const Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 3,
                backgroundColor: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
