import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/mini_test.dart';

import '../../../Features/tests/domain/entities/test/test.dart';
import '../../../Features/tests/domain/usecases/get_my_tests_uc.dart';

class PickMiniTestView extends StatefulWidget {
  const PickMiniTestView(
      {super.key, required this.afterPIck, required this.material});
  final String material;
  final Function(MiniTest) afterPIck;
  @override
  State<PickMiniTestView> createState() => _PickMiniTestViewState();
}

class _PickMiniTestViewState extends State<PickMiniTestView> {
  bool loading = true;
  List<Test> myTests = [];
  @override
  void initState() {
    fetchTests();
    super.initState();
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
          : ListView.builder(
              itemCount: myTests.length,
              itemBuilder: (context, index) {
                return TouchableTileWidget(
                  title: myTests[index].information.title,
                  onTap: () {
                    widget.afterPIck(
                      MiniTest(
                        id: myTests[index].id,
                        title: myTests[index].information.title,
                        material: myTests[index].information.material,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
    );
  }
}
