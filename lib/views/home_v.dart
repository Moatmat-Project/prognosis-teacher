import 'package:flutter/material.dart';
import 'package:moatmat_teacher/views/bank/add_bank_first_stage_v.dart';
import 'package:moatmat_teacher/views/test/add_test_first_stage_v.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الصفحة الرئيسية"),
      ),
      body: Column(
        children: [
          HomeScreenItemWidget(
            title: "اضافة اختبار",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddTestFirstStageView(),
                ),
              );
            },
          ),
          HomeScreenItemWidget(
            title: "اضافة بنك",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddBankFirstStageView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomeScreenItemWidget extends StatelessWidget {
  const HomeScreenItemWidget({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          onTap: onTap,
          title: Text(title),
        ),
      ),
    );
  }
}
