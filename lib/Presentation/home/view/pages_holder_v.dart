
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Presentation/attendance/views/explore_attendance_view.dart';
import 'package:moatmat_teacher/Presentation/folders/view/folders_views_manager.dart';
import 'package:moatmat_teacher/Presentation/home/view/home_v.dart';
import 'package:moatmat_teacher/Presentation/purchases/view/purchases_v.dart';

import '../../banks/views/my_banks_v.dart';

class PagesHolderView extends StatefulWidget {
  const PagesHolderView({super.key});

  @override
  State<PagesHolderView> createState() => _PagesHolderViewState();
}

class _PagesHolderViewState extends State<PagesHolderView> {
  int index = 0;
  late final PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: index,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
        },
        children: [
          const HomeView(),
          FoldersViewManager(
            title: "البنوك",
            isTest: false,
            openAll: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyBanksView(),
                ),
              );
            },
          ),
          ExploreAttendanceView(),
          const PurchasesView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorsResources.background,
        selectedItemColor: ColorsResources.primary,
        unselectedItemColor: ColorsResources.borders,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
          _pageController.jumpToPage(value);
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
            ),
            icon: Icon(
              Icons.home,
            ),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.library_books,
            ),
            icon: Icon(
              Icons.library_books,
            ),
            label: "البنوك",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              // icon for attendance
              Icons.app_registration_outlined,
            ),
            icon: Icon(
              Icons.app_registration_outlined,
            ),
            label: "الجلسات",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.settings_applications_sharp,
            ),
            icon: Icon(
              Icons.settings_applications_sharp,
            ),
            label: "الاشتراكات",
          ),
        ],
      ),
    );
  }
}
