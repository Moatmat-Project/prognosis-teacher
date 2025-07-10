import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Presentation/reports/state/reports/reports_cubit.dart';

import '../../../Presentation/notifications/state/notifications_bloc/notifications_bloc.dart';
import '../../../Presentation/notifications/views/notifications_view.dart';
import '../../resources/colors_r.dart';

class NotificationsIconWidget extends StatefulWidget {
  const NotificationsIconWidget({super.key});

  @override
  State<NotificationsIconWidget> createState() => _NotificationsIconWidgetState();
}

class _NotificationsIconWidgetState extends State<NotificationsIconWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<NotificationsBloc, NotificationsState, bool>(
      selector: (s) => false,
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationsView(),
              ),
            );
          },
          icon: _NotificationIcon(state),
        );
      },
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final bool unread;
  const _NotificationIcon(this.unread, {super.key});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: unread,
      backgroundColor: ColorsResources.red,
      offset: const Offset(6, -12),
      smallSize: 4,
      largeSize: 8,
      alignment: Alignment.topRight,
      child: Icon(
        Icons.notifications,
        size: 22,
      ),
    );
  }
}
