import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:moatmat_teacher/Core/functions/pdf/export_questions_horizontal_pdf.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/spacing_resources.dart';
import 'package:moatmat_teacher/Core/services/export_repository_s.dart';
import 'package:moatmat_teacher/Core/widgets/fields/attachment_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/drop_down_w.dart';
import 'package:moatmat_teacher/Core/widgets/fields/elevated_button_widget.dart';
import 'package:moatmat_teacher/Core/widgets/fields/picking_w.dart';
import 'package:moatmat_teacher/Core/widgets/toucheable_tile_widget.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Presentation/export/other/export_test_options.dart';
import 'package:moatmat_teacher/Presentation/export/other/question_image_information.dart';
import 'package:moatmat_teacher/Presentation/export/widgets/horizontal_pdf_question_w.dart';
import 'package:moatmat_teacher/Presentation/export/widgets/vertical_pdf_question_w.dart';
import 'package:open_file/open_file.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../Core/resources/sizes_resources.dart';
import '../../../../Core/validators/not_empty_v.dart';
import '../../../../Core/widgets/fields/text_input_field.dart';
import '../../other/print_type.dart';

class ExportQuestionsView extends StatefulWidget {
  const ExportQuestionsView({
    super.key,
    required this.questions,
    required this.title,
    required this.teacher,
    this.period,
  });
  final String title;
  final String teacher;
  final int? period;
  final List<Question> questions;
  @override
  State<ExportQuestionsView> createState() => _ExportQuestionsViewState();
}

class _ExportQuestionsViewState extends State<ExportQuestionsView> {
  //
  late ExportTestOptions exportTestOptions;
  //
  late GlobalKey<FormState> _formKey;
  //
  List<String> files = [];
  //
  List<Question> questions = [];
  List<Widget> questionsWidgets = [];
  //
  List<ScreenshotController> controllers = [];
  //
  List<QuestionImageInformation> imagesFiles = [];
  //
  String? text;
  //
  bool exported = false;
  //
  @override
  void initState() {
    //
    exportTestOptions = ExportTestOptions(
      formsCount: 1,
      minutes: widget.period != null ? (widget.period! ~/ 60) : null,
      email: widget.teacher,
      printType: PrintType.horizontal,
      specialOrder: null,
      waterMark: null,
      questions: widget.questions,
    );
    //
    _formKey = GlobalKey<FormState>();
    //
    WidgetsBinding.instance.addPostFrameCallback((t) {
      try {
        preCashImages();
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
          ),
        );
      }
    });
    //
    super.initState();
  }

  exportAll() async {
    //
    files = [];
    //
    setState(() => text = "جاري تجهيز الأسئلة للطباعة");
    //
    for (int i = 0; i < exportTestOptions.formsCount; i++) {
      files.add(await export(numberToLetter(i + 1)));
      setState(() {});
    }
    //
    setState(() {
      text = "تم تصدير الملفات";
      exported = true;
    });
  }

  Future setUpImages() async {
    //
    setState(() {
      questionsWidgets = [];
      controllers = [];
    });
    //
    List<Question> questionsToShuffle = List.from(exportTestOptions.questions);
    //
    List<Question> shuffledQuestions = shuffleWithGroups<Question>(questionsToShuffle, exportTestOptions.specialOrder ?? []);
    //
    List<Question> questionsForWidgets = shuffledQuestions;
    //
    for (int i = 0; i < questionsForWidgets.length; i++) {
      //
      controllers.add(ScreenshotController());
      //
      questionsWidgets.add(
        exportTestOptions.printType == PrintType.horizontal
            ? HorizontalPDFQuestionWidget(
                id: i + 1,
                key: UniqueKey(),
                question: questionsForWidgets[i],
                controller: controllers[i],
              )
            : VerticalPDFquestionWidget(
                id: i + 1,
                key: UniqueKey(),
                question: questionsForWidgets[i],
                controller: controllers[i],
              ),
      );
    }
    //
    questionsWidgets.add(Container(color: ColorsResources.background));
    //
    setState(() {});
  }

  Future<String> export(String form) async {
    //
    await setUpImages();
    //
    await WidgetsBinding.instance.endOfFrame;
    await Future.delayed(Duration(seconds: 2));
    //
    imagesFiles = [];
    //
    for (int i = 0; i < controllers.length; i++) {
      var img = await ExportRepositoryService().widgetToImageInformation(
        controller: controllers[i],
        rect: getRect(),
      );
      imagesFiles.add(img);
    }
    if (exportTestOptions.printType == PrintType.horizontal) {
      var path = await exportQuestionsHorizontalPdf(
        images: imagesFiles,
        exportTestOptions: exportTestOptions,
        title: widget.title,
        form: form,
      );

      return path;
    } else {
      var path = await ExportRepositoryService().toPdf(
        imagesFiles,
        exportTestOptions: exportTestOptions,
        title: "title",
        form: form,
      );

      return path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: exported
                ? () async {
                    await Share.shareXFiles(
                      files.map((e) => XFile(e)).toList(),
                    );
                  }
                : null,
            child: const Text("مشاركة الملفات"),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: questionsWidgets,
              ),
            ),
          ),
          Container(
            color: ColorsResources.background,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: SizesResources.s4),
                if (text == null) ...[
                  DropDownWidget(
                    items: List.generate(6, (i) => "${i + 1}"),
                    hintText: "عدد النماذج",
                    selectedItem: exportTestOptions.formsCount.toString(),
                    onChanged: (p0) {
                      if (text != null) {
                        return;
                      }
                      exportTestOptions.formsCount = int.parse(p0!);
                    },
                    onSaved: (p0) {},
                  ),
                  const SizedBox(height: SizesResources.s4),
                  MyTextFormFieldWidget(
                    hintText: "اسم المعلم",
                    maxLines: 1,
                    initialValue: exportTestOptions.email,
                    validator: (t) {
                      return notEmptyValidator(text: t);
                    },
                    onSaved: (value) {
                      setState(() {
                        exportTestOptions.email = value!;
                      });
                    },
                  ),
                  const SizedBox(height: SizesResources.s4),
                  MyTextFormFieldWidget(
                    hintText: "وقت الاختبار",
                    maxLines: 1,
                    initialValue: exportTestOptions.minutes.toString(),
                    validator: (t) {
                      return notEmptyValidator(text: t);
                    },
                    onSaved: (value) {
                      if (value == null || value.isEmpty) {
                        return;
                      }
                      if (int.tryParse(value) == null) {
                        setState(() {
                          exportTestOptions.minutes = int.parse(value);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: SizesResources.s4),
                  PickingWidget<PrintType>(
                    onChanged: (value) {
                      setState(() {
                        exportTestOptions.printType = value;
                      });
                    },
                    selected: exportTestOptions.printType,
                    option1: PrintType.horizontal,
                    option2: PrintType.vertical,
                    optionName: (PrintType value) {
                      return printTypeToString[value]!;
                    },
                  ),
                  const SizedBox(height: SizesResources.s4),
                  MyTextFormFieldWidget(
                      hintText: "ترتيب مخصص",
                      suffix: IconButton(
                        onPressed: () {
                          // show dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("ترتيب مخصص"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: SizesResources.s2),
                                    const Text("قم بتحديد ترتيب ثابت لبعض الاسئلة للحفاظ على التسلسل"),
                                    const SizedBox(height: SizesResources.s1),
                                    const Text("يمثل كل سطر تسلسل عدة أسئلة"),
                                    const SizedBox(height: SizesResources.s1),
                                    const Text("يجب ان تكون الأسئلة مفصولة بفاصلة"),
                                    const SizedBox(height: SizesResources.s1),
                                    SizedBox(
                                      width: SpacingResources.mainWidth(context),
                                      child: Text(
                                        "مثال : ",
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      width: SpacingResources.mainWidth(context),
                                      child: Text(
                                        "4,5\n10,11",
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("حسنا"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.info_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return null;

                        final trimmed = value.trim();

                        // Disallow lines starting/ending with comma or empty lines
                        final lines = trimmed.split('\n').map((line) => line.trim()).toList();
                        for (final line in lines) {
                          if (line.isEmpty) return "لا يُسمح بخطوط فارغة";
                          if (line.startsWith(',') || line.startsWith('،') || line.endsWith(',') || line.endsWith('،')) {
                            return "لا يجب أن تبدأ أو تنتهي الأسطر بفاصلة";
                          }
                          if (RegExp(r'(,|،){2,}').hasMatch(line)) {
                            return "لا يُسمح بفواصل متتالية";
                          }
                          if (!RegExp(r'^[0-9\u0660-\u0669]+([,،][0-9\u0660-\u0669]+)*$').hasMatch(line)) {
                            return "يُسمح فقط بالأرقام والفواصل في كل سطر";
                          }
                        }

                        // Convert to [[int]]
                        exportTestOptions.specialOrder = lines.map((line) {
                          return line.split(RegExp(r'[,،]')).map((part) {
                            final char = part.trim();
                            return RegExp(r'^[\u0660-\u0669]$').hasMatch(char) ? char.codeUnitAt(0) - 0x0660 : int.parse(char);
                          }).toList();
                        }).toList();

                        return null;
                      }),
                  const SizedBox(height: SizesResources.s4),
                  AttachmentWidget(
                    title: "علامة مائية",
                    fileType: FileType.image,
                    file: exportTestOptions.waterMark,
                    afterPick: (p0) {
                      setState(() {
                        exportTestOptions.waterMark = p0;
                      });
                    },
                    onDelete: () {
                      setState(() {
                        exportTestOptions.waterMark = null;
                      });
                    },
                  ),
                  const SizedBox(height: SizesResources.s4),
                ],
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: SizesResources.s2,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return TouchableTileWidget(
                        title: "النموذج  ${numberToLetter(index + 1)}",
                        onTap: () {
                          OpenFile.open(files[index]);
                        },
                      );
                    },
                  ),
                ),
                // SingleChildScrollView(
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: HorizontalPDFQuestionWidget(
                //       id: 0,
                //       question: widget.questions[55],
                //       controller: ScreenshotController(),
                //     ),
                //   ),
                // ),
                ElevatedButtonWidget(
                  text: text != null ? text! : "تصدير",
                  onPressed: text != null
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            try {
                              exportAll();
                            } on Exception catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$e"),
                                ),
                              );
                            }
                          }
                        },
                ),
                const SizedBox(height: SizesResources.s10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future preCashImages() async {
    //
    setState(() => text = "جاري معالجة الصور");
    //
    await ExportRepositoryService().preCashImages(
      questions: widget.questions,
      context: context,
    );
    //
    setState(() => text = null);
    //
  }

  Rect getRect() {
    return Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
    );
  }
}

String numberToLetter(int number) {
  if (number < 1 || number > 26) {
    throw RangeError('Number must be between 1 and 26');
  }

  return String.fromCharCode(64 + number);
}

List<T> shuffleWithGroups<T>(List<T> items, List<List<int>> lockedGroups) {
  if (kDebugMode) return items;
  final List<T> result = [];
  final Set<int> usedIndexes = {};
  //
  // Extract and group locked items
  final List<List<T>> groupedItems = [];
  for (final group in lockedGroups) {
    final groupItems = group.map((i) => items[i]).toList();
    groupedItems.add(groupItems);
    usedIndexes.addAll(group);
  }

  // Add remaining (ungrouped) items as single-item groups
  for (int i = 0; i < items.length; i++) {
    if (!usedIndexes.contains(i)) {
      groupedItems.add([items[i]]);
    }
  }

  // Shuffle the groups
  groupedItems.shuffle();

  // Flatten the result
  for (final group in groupedItems) {
    result.addAll(group);
  }

  return result;
}
