import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/cards/home_feature_card_w.dart';
import 'package:moatmat_teacher/Core/widgets/appbar/notifications_icon_w.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Presentation/auth/state/auth_c/auth_cubit_cubit.dart';
import 'package:moatmat_teacher/Presentation/banks/views/add_bank_view.dart';
import 'package:moatmat_teacher/Presentation/groups/views/groups_views_manager.dart';
import 'package:moatmat_teacher/Presentation/notifications/views/notifications_view.dart';
import 'package:moatmat_teacher/Presentation/notifications/views/send_notification_view.dart';
import 'package:moatmat_teacher/Presentation/scanner/views/scanner_views_manager.dart';
import 'package:moatmat_teacher/Presentation/students/views/add_results_v.dart';
import 'package:moatmat_teacher/Presentation/tests/views/add_test_vew.dart';
import '../../../Core/widgets/appbar/contact_us_w.dart';
import '../../../Core/widgets/appbar/notifications_icon_w.dart';
import '../../../Core/widgets/appbar/report_icon_w.dart';
import '../../../Core/widgets/appbar/search_icon_w.dart';
import '../../scanner/state/cubit/explore_outer_tests_cubit.dart';
import '../../students/views/my_students_v.dart';
import '../../tests/views/add_outer_test_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الصفحة الرئيسية"),
        actions: const [
          // SearchIconWidget(),
          ReportIconWidget(),
          NotificationsIconWidget(),
          ContactUsWidget(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: SizesResources.s4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SizesResources.s2),
            child: Column(
              children: [
                HomeFeatureCard(
                  title: "ادارة المجموعات",
                  icon: Icons.group_outlined,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GroupsViewsManager(),
                      ),
                    );
                  },
                ),
                HomeFeatureCard(
                  title: "طلابي",
                  icon: Icons.school_outlined,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyStudentsView(),
                    ));
                  },
                ),
                HomeFeatureCard(
                  title: "ارسال اشعارات",
                  icon: Icons.notification_add_outlined,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SendNotificationView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: SizesResources.s4),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SpeedDial(
        backgroundColor: ColorsResources.primary,
        foregroundColor: ColorsResources.whiteText1,
        animatedIcon: AnimatedIcons.menu_home,
        children: [
          SpeedDialChild(
            label: "تسجيل الخروج",
            child: const Icon(Icons.logout_outlined),
            onTap: () async {
              context.read<AuthCubit>().startSignOut();
            },
          ),
          SpeedDialChild(
            label: "تبديل الحساب",
            child: const Icon(Icons.switch_account_outlined),
            onTap: () async {
              context.read<AuthCubit>().startFastAuth();
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "إضافة بنك",
            child: const Icon(Icons.account_balance_outlined),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddBankView(),
                ),
              );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          // SpeedDialChild(
          //   label: "إضافة أختبار",
          //   child: const Icon(Icons.quiz_outlined),
          //   onTap: () async {
          //     await Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => const AddTestView()),
          //     );
          //     FocusManager.instance.primaryFocus?.unfocus();
          //   },
          // ),
          SpeedDialChild(
            label: "تصميم سلم اختبار خارجي",
            child: const Icon(Icons.rule_outlined),
            onTap: () async {
              await Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const AddOuterTestView(),
                    ),
                  )
                  .then(
                    (value) => context.read<ExploreOuterTestsCubit>().init(),
                  );
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          SpeedDialChild(
            label: "رفع ملف علامات",
            child: const Icon(Icons.upload_file_outlined),
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddResultsView(),
                ),
              );
            },
          ),
          if (locator<TeacherData>().options.allowScanning || kDebugMode)
            SpeedDialChild(
              label: "تصحيح اختبار",
              child: const Icon(Icons.scanner_outlined),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ScannerViewsManager(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
