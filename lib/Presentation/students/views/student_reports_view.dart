import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Core/widgets/view/search_in_reports_v.dart';
import 'package:moatmat_teacher/Presentation/students/state/student_reports/student_reports_cubit.dart';
import 'package:moatmat_teacher/Presentation/students/widgets/result_tile_w.dart';

import '../../../Features/students/domain/entities/result.dart';

class StudentReportsView extends StatefulWidget {
  const StudentReportsView({super.key, required this.results});
  final List<Result> results;
  @override
  State<StudentReportsView> createState() => _StudentReportsViewState();
}

class _StudentReportsViewState extends State<StudentReportsView> {
  @override
  void initState() {
    context.read<StudentReportsCubit>().init(widget.results);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudentReportsCubit, StudentReportsState>(
        builder: (context, state) {
          if (state is StudentReportsInitial) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("تقارير الطالب"),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'اختبارات'),
                      Tab(text: 'بنوك'),
                      Tab(text: 'اختبارات خارجية'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    StudentReportsDetailsView(items: state.testsReportInfo),
                    StudentReportsDetailsView(items: state.banksReportInfo),
                    StudentReportsDetailsView(items: state.outerTestsReportInfo),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}

class StudentReportsDetailsView extends StatelessWidget {
  const StudentReportsDetailsView({super.key, required this.items});
  final List<ReportItem> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        SizedBox(height: SizesResources.s5),
        //
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: SpacingResources.mainWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(SizesResources.s3).copyWith(top: SizesResources.s4),
                    width: SpacingResources.mainHalfWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsResources.onPrimary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "تم حلها",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          items.where((i) => i.results.isNotEmpty).length.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(SizesResources.s3).copyWith(top: SizesResources.s4),
                    width: SpacingResources.mainHalfWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsResources.onPrimary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "لم يتم حلها",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          items.where((i) => i.results.isEmpty).length.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        //
        SizedBox(height: SizesResources.s2),
        //
        TouchableTileWidget(
          title: 'تصفح الاختبارات التي تم حلها',
          iconData: Icons.arrow_forward_ios,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportsItemsView(items: items.where((e) => e.results.isNotEmpty).toList()),
              ),
            );
          },
        ),
        TouchableTileWidget(
          title: 'تصفح الاختبارات التي لم يتم حلها',
          iconData: Icons.arrow_forward_ios,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportsItemsView(items: items.where((e) => e.results.isEmpty).toList()),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ReportsItemsView extends StatelessWidget {
  const ReportsItemsView({super.key, required this.items});
  final List<ReportItem> items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchInReportsView(
                    reports: items,
                    onPick: (test) {},
                  ),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return TouchableTileWidget(
            title: items[index].title,
            subTitle: "اضغط لعرض نتائج الطالب بالاختبار",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ResultsView(
                    results: items[index].results,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ResultsView extends StatelessWidget {
  const ResultsView({super.key, required this.results});
  final List<Result> results;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: results.isEmpty
          ? Center(
              child: Text("لا يوجد عناصر"),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ResultTileWidget(
                  result: results[index],
                );
              },
            ),
    );
  }
}
