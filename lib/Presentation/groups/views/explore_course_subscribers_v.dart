import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/groups/data/models/group_item_m.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_my_students_uc.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../notifications/views/send_bulk_notification_v.dart';
import '../../statistics/views/export_students_statistics_view.dart';
import '../../students/views/my_students_v.dart';
import '../../students/views/students_statistics_v.dart';
import 'manage_group_tests_view.dart';

class ExploreCourseSubscribersView extends StatefulWidget {
  const ExploreCourseSubscribersView({super.key});

  @override
  State<ExploreCourseSubscribersView> createState() => _ExploreCourseSubscribersViewState();
}

class _ExploreCourseSubscribersViewState extends State<ExploreCourseSubscribersView> {
  //
  late bool isLoading = true;
  //
  late List<UserData> subscribers;
  late List<UserData> search;
  //
  late final TextEditingController _controller;
  //
  @override
  void initState() {
    //
    subscribers = [];
    search = [];
    //
    _controller = TextEditingController();
    //
    _controller.addListener(() {
      search = subscribers.where((e) {
        bool con1 = e.name.contains(_controller.text);
        bool con2 = _controller.text.isEmpty;
        return con1 || con2;
      }).toList();
      setState(() {});
    });
    //
    loadSubscribers();
    //
    super.initState();
  }

  Future<void> loadSubscribers() async {
    final response = await locator<GetMyStudentsUC>().call(
      excludeBanks: true,
      excludeTests: true,
    );
    response.fold(
      (l) {
        setState(() {
          isLoading = false;
        });
      },
      (r) {
        setState(() {
          isLoading = false;
          subscribers = r.students;
          search = subscribers;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مشتركين الكورس"),
        centerTitle: false,
        actions: isLoading
            ? []
            : [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SendBulkNotificationView(
                          usersData: subscribers,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notification_add),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => ExportStudentsStatisticsView(
                          students: subscribers,
                        ),
                      ),
                    );
                  },
                  // statistic icon
                  icon: const Icon(Icons.insert_chart),
                ),
              ],
      ),
      body: isLoading
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: SizesResources.s2),
                MyTextFormFieldWidget(
                  hintText: "بحث",
                  suffix: const Icon(Icons.search),
                  controller: _controller,
                ),
                const SizedBox(height: SizesResources.s2),
                SizedBox(
                  height: 50,
                  width: SpacingResources.mainWidth(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsResources.primary.withAlpha(50),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(7),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ManageGroupTestsView(
                                group: Group(
                                  id: 0,
                                  name: "",
                                  classRoom: "",
                                  items: subscribers
                                      .map(
                                        (e) => GroupItemModel(
                                          id: 0,
                                          customClass: null,
                                          userData: e,
                                        ),
                                      )
                                      .toList(),
                                  testsIds: locator<TeacherData>().courseSubscribersTests,
                                ),
                                isCourseSubscribersGroup: true,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.filter_list,
                                color: ColorsResources.primary,
                                size: 24,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3, right: 8),
                                child: Text(
                                  "ادارة اختبارات مشتركين الكورس",
                                  style: TextStyle(
                                    color: ColorsResources.primary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SizesResources.s2),
                SizedBox(
                  width: SpacingResources.mainWidth(context),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text("عدد المشتركين : ${subscribers.length}"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SizesResources.s2),
                Expanded(
                  child: ListView.builder(
                    itemCount: search.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          StudentTileWidget(
                            userData: search[index],
                            onLongPress: () {},
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
