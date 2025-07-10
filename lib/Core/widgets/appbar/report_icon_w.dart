import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Presentation/reports/state/reports/reports_cubit.dart';

import '../../../Presentation/reports/view/reports_v.dart';

class ReportIconWidget extends StatefulWidget {
  const ReportIconWidget({super.key});

  @override
  State<ReportIconWidget> createState() => _ReportIconWidgetState();
}

class _ReportIconWidgetState extends State<ReportIconWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ReportsCubit, ReportsState, bool>(
      selector: (state) {
        return state is ReportsInitial ? state.newReports : false;
      },
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ReportsView(),
            ));
          },
          icon: _ReportIcon(state),
        );
      },
    );
  }
}

class _ReportIcon extends StatelessWidget {
  final bool unread;
  const _ReportIcon(this.unread);

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
        Icons.report,
        size: 22,
      ),
    );
  }
}
