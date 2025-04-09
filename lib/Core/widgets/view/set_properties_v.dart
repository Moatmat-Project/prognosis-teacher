import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/sizes_resources.dart';
import 'package:moatmat_teacher/Core/widgets/fields/checking_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test_properties.dart';

class SetPropertiesView extends StatefulWidget {
  const SetPropertiesView({
    super.key,
    this.afterSet,
    this.exploreAnswers,
    this.timePerQuestion,
    this.repeatable,
    this.showAnswers,
    this.visible,
    this.scrollable,
    this.isTest = true,
    required this.onPop,
  });
  //
  final bool? exploreAnswers;
  final bool? timePerQuestion;
  final bool? repeatable;
  final bool? showAnswers;
  final bool? visible;
  final bool? scrollable;
  final bool isTest;
  //
  final VoidCallback onPop;
  //
  final Function({
    required bool? exploreAnswers,
    required bool? showAnswers,
    required bool? timePerQuestion,
    required bool? repeatable,
    required bool? visible,
    required bool? scrollable,
  })? afterSet;
  //
  @override
  State<SetPropertiesView> createState() => _SetPropertiesViewState();
}

class _SetPropertiesViewState extends State<SetPropertiesView> {
  //
  late TestProperties properties;
  late bool exploreAnswers;
  late bool timePerQuestion;
  late bool repeatable;
  late bool showAnswers;
  late bool visible;
  late bool scrollable;
  @override
  void initState() {
    exploreAnswers = widget.exploreAnswers ?? true;
    timePerQuestion = widget.timePerQuestion ?? false;
    repeatable = widget.repeatable ?? false;
    showAnswers = widget.showAnswers ?? true;
    visible = widget.visible ?? true;
    scrollable = widget.scrollable ?? false;
    super.initState();
  }

  onUpdate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTest ? "خصائص الاختبار" : "خصائص البنك"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              widget.onPop();
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: SizesResources.s2),
            if (widget.isTest)
              CheckingWidget(
                title: "تصفح الإجابات الخاطئة",
                value: exploreAnswers,
                onChanged: (value) {
                  exploreAnswers = value ?? false;
                  onUpdate();
                },
              ),
            if (widget.isTest)
              CheckingWidget(
                title: "تعيين المدة للسؤال الواحد",
                value: timePerQuestion,
                onChanged: (value) {
                  timePerQuestion = value ?? false;
                  onUpdate();
                },
              ),
            if (widget.isTest)
              CheckingWidget(
                title: "هل الاختبار قابل للاعادة",
                value: repeatable,
                onChanged: (value) {
                  repeatable = value ?? false;
                  onUpdate();
                },
              ),
            if (widget.isTest)
              CheckingWidget(
                title: "عرض الاجابة الصحيحة",
                value: showAnswers,
                onChanged: (value) {
                  showAnswers = value ?? true;
                  onUpdate();
                },
              ),
            CheckingWidget(
              title: "اخفاء",
              value: !visible,
              onChanged: (value) {
                if (value == null) return;
                onUpdate();

                visible = !value;
              },
            ),
            CheckingWidget(
              title: "تفعيل السكرول",
              value: scrollable,
              onChanged: (value) {
                if (value == null) return;
                onUpdate();
                scrollable = value;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: SizesResources.s10),
        child: ElevatedButtonWidget(
          text: "تعيين الخصائص",
          onPressed: () async {
            widget.afterSet!(
              exploreAnswers: exploreAnswers,
              timePerQuestion: timePerQuestion,
              repeatable: repeatable,
              showAnswers: showAnswers,
              visible: visible,
              scrollable: scrollable,
            );
          },
        ),
      ),
    );
  }
}
