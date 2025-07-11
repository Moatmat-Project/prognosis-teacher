import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/mini_test.dart';

import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/widgets/fields/text_input_field.dart';
import '../../../Features/tests/domain/entities/test/test.dart';
import '../../../Features/tests/domain/usecases/get_my_tests_uc.dart';

class PickMiniTestView extends StatefulWidget {
  const PickMiniTestView({super.key, required this.afterPIck, required this.material});
  final String material;
  final Function(MiniTest) afterPIck;
  @override
  State<PickMiniTestView> createState() => _PickMiniTestViewState();
}

class _PickMiniTestViewState extends State<PickMiniTestView> {
  bool loading = true;
  List<Test> myTests = [];
  List<Test> searchResults = [];
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        searchResults = myTests;
      } else {
        searchResults = myTests.where((e) {
          return e.information.title.contains(_controller.text);
        }).toList();
      }
      setState(() {});
    });
    fetchTests();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  fetchTests() async {
    final testsRes = await locator<GetMyTestsUC>().call();
    testsRes.fold(
      (l) {},
      (r) {
        setState(() {
          myTests = r.where((e) {
            return e.information.material == widget.material;
          }).toList();
          searchResults = myTests;
        });
      },
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: loading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: [
                //
                const SizedBox(height: SizesResources.s2),
                //
                MyTextFormFieldWidget(
                  hintText: "ابحث عن اختبار",
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                ),
                //
                const SizedBox(height: SizesResources.s2),
                //
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return TouchableTileWidget(
                        title: searchResults[index].information.title,
                        onTap: () {
                          widget.afterPIck(
                            MiniTest(
                              id: searchResults[index].id,
                              title: searchResults[index].information.title,
                              material: searchResults[index].information.material,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
