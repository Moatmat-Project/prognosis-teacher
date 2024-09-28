import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ReportsView(),
            ));
          },
          icon: Stack(
            children: [
              const Icon(
                Icons.notifications,
              ),
              Opacity(
                opacity: (state is ReportsInitial && state.newReports) ? 1 : 0,
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
      },
    );
  }
}
