import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Presentation/attendance/views/explore_attendance_view.dart';

import '../state/auth_c/auth_cubit_cubit.dart';

class OfflineView extends StatefulWidget {
  const OfflineView({
    super.key,
  });
  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("وضع الاوفلاين"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().init();
            },
            icon: Icon(Icons.replay_outlined),
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            //
            SizedBox(height: SizesResources.s6),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: SpacingResources.mainWidth(context),
                  decoration: BoxDecoration(
                    color: ColorsResources.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorsResources.darkPrimary,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExploreAttendanceView(
                              isOffline: true,
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          "جلسات الحضور",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorsResources.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
