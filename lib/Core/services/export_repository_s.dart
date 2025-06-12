// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_teacher/Core/widgets/pdf/footer_w.dart';
import 'package:moatmat_teacher/Core/widgets/pdf/header_w.dart';
import 'package:moatmat_teacher/Presentation/export/other/export_test_options.dart';
import 'package:moatmat_teacher/Presentation/export/other/question_image_information.dart';
import 'package:moatmat_teacher/Presentation/export/widgets/horizontal_pdf_question_w.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:pdf/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

const double maxColumnHeight = 730; //831
const double maxItemWidth = 275; //831
const double headerHeight = 65; //831
const int itemWidth = 240; //831

class ExportRepositoryService {
  //
  Future toPdf(
    List<QuestionImageInformation> images, {
    required ExportTestOptions exportTestOptions,
    required String title,
    required String form,
  }) async {
    //
    final pdf = pw.Document();
    //
    var reqFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Arial/arial.ttf"),
    );
    var boldFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Arial/arial-bold.ttf"),
    );

    var res = imageInformationToPages(
      qInformation: images,
      reqFont: reqFont,
      boldFont: boldFont,
      title: title,
      form: form,
      minutes: exportTestOptions.minutes,
      email: exportTestOptions.email,
    );
    for (var r in res) {
      pdf.addPage(r);
    }

    // Save the PDF file to local storage
    var directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/results_of_${title}_$form.pdf';
    final file = File(filePath);
    var pdfFile = await file.writeAsBytes(await pdf.save());

    return pdfFile.path;
  }

  //
  List<pw.Page> imageInformationToPages({
    required List<QuestionImageInformation> qInformation,
    required Font reqFont,
    required Font boldFont,
    required String title,
    required String form,
    required int? minutes,
    required String email,
  }) {
    //
    int curentIndex = 0;
    //
    List<(List<QuestionImageInformation>, List<QuestionImageInformation>)> list = [];
    //
    //
    for (var q in qInformation) {
      //
      // check if list is empty.
      if (!(curentIndex < list.length)) {
        list.add(([], []));
      }
      //
      if (canAdd(list: list[curentIndex].$1, item: q, index: curentIndex)) {
        list[curentIndex].$1.add(q);
      } else if (canAdd(list: list[curentIndex].$2, item: q, index: curentIndex)) {
        list[curentIndex].$2.add(q);
      } else {
        curentIndex++;
        list.add(([], []));
        list[curentIndex].$1.add(q);
      }
    }

    List<pw.Page> result = [];

    //
    int counter = 0;
    //
    for (int i = 0; i < list.length; i++) {
      result.add(
        pw.MultiPage(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          footer: (context) {
            return getFooter(
              footerHeight: 34,
              pageNumber: context.pageNumber,
              pagesCount: context.pagesCount,
              isLastPage: context.pageNumber == context.pagesCount,
            );
          },
          header: (context) {
            if (i != 0) {
              return pw.SizedBox();
            }
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.SizedBox(
                height: headerHeight,
                child: getHeader(
                  title: title,
                  email: email,
                  form: form,
                  headerHeight: headerHeight,
                ),
              ),
            );
          },
          pageTheme: pw.PageTheme(
            theme: pw.ThemeData.withFont(
              base: reqFont,
              bold: boldFont,
            ),
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.symmetric(
              horizontal: 25,
            ),
          ),
          build: (context) {
            return [
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.SizedBox(
                  width: maxItemWidth * 2,
                  height: maxColumnHeight,
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 1,
                              ),
                            ),
                            width: maxItemWidth,
                            height: maxColumnHeight,
                            child: pw.Column(
                              mainAxisAlignment: (i == list.length - 1 || list[i].$2.length == 1) ? pw.MainAxisAlignment.start : pw.MainAxisAlignment.spaceBetween,
                              children: List.generate(list[i].$1.length, (i2) {
                                //
                                counter++;
                                //

                                final e = list[i].$1[i2];
                                //
                                if (i == list.length - 1 || list[i].$2.length == 1) {
                                  return pw.Expanded(
                                    flex: newHeight(
                                      e.height.toDouble(),
                                      list[i].$2.fold(
                                            0,
                                            (previousValue, element) => previousValue + element.height,
                                          ),
                                    ).toInt(),
                                    child: pw.Container(
                                      width: maxItemWidth - 2,
                                      alignment: pw.Alignment.topLeft,
                                      decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                          bottom: pw.BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Row(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Padding(
                                              child: pw.Text(
                                                "- $counter",
                                                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                              ),
                                              padding: const pw.EdgeInsets.only(
                                                top: 10,
                                              ),
                                            ),
                                            pw.Image(
                                              pw.MemoryImage(e.bytes),
                                              width: e.width * 0.93,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                //
                                return pw.Expanded(
                                  flex: newHeight(
                                    e.height.toDouble(),
                                    list[i].$2.fold(
                                          0,
                                          (previousValue, element) => previousValue + element.height,
                                        ),
                                  ).toInt(),
                                  child: pw.Container(
                                    width: maxItemWidth - 2,
                                    alignment: pw.Alignment.topLeft,
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        bottom: pw.BorderSide(
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Row(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Padding(
                                            child: pw.Text(
                                              "- $counter",
                                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                            ),
                                            padding: const pw.EdgeInsets.only(
                                              top: 10,
                                            ),
                                          ),
                                          pw.Image(
                                            pw.MemoryImage(e.bytes),
                                            width: e.width * 0.93,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          ///////////
                          ///////////
                          ///////////
                          ///////////
                          ///////////
                          ///////////
                          pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 1,
                              ),
                            ),
                            width: maxItemWidth,
                            height: maxColumnHeight,
                            child: pw.Column(
                              mainAxisAlignment: (i == list.length - 1 || list[i].$2.length == 1) ? pw.MainAxisAlignment.start : pw.MainAxisAlignment.spaceBetween,
                              children: List.generate(list[i].$2.length, (i2) {
                                //
                                counter++;
                                //
                                final e = list[i].$2[i2];
                                //
                                if (i == list.length - 1 || list[i].$2.length == 1) {
                                  return pw.Expanded(
                                    flex: newHeight(
                                      e.height.toDouble(),
                                      list[i].$2.fold(
                                            0,
                                            (previousValue, element) => previousValue + element.height,
                                          ),
                                    ).toInt(),
                                    child: pw.Container(
                                      width: maxItemWidth - 2,
                                      alignment: pw.Alignment.topLeft,
                                      decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                          bottom: pw.BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: pw.Padding(
                                        padding: const pw.EdgeInsets.all(5),
                                        child: pw.Row(
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Padding(
                                              child: pw.Text(
                                                "- $counter",
                                                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                              ),
                                              padding: const pw.EdgeInsets.only(
                                                top: 10,
                                              ),
                                            ),
                                            pw.Image(
                                              pw.MemoryImage(e.bytes),
                                              width: e.width * 0.93,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                //
                                return pw.Expanded(
                                  flex: newHeight(
                                    e.height.toDouble(),
                                    list[i].$2.fold(
                                          0,
                                          (previousValue, element) => previousValue + element.height,
                                        ),
                                  ).toInt(),
                                  child: pw.Container(
                                    width: maxItemWidth - 2,
                                    alignment: pw.Alignment.topLeft,
                                    decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                        bottom: pw.BorderSide(
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.all(5),
                                      child: pw.Row(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Padding(
                                            child: pw.Text(
                                              "- $counter",
                                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                                            ),
                                            padding: const pw.EdgeInsets.only(
                                              top: 10,
                                            ),
                                          ),
                                          pw.Image(
                                            pw.MemoryImage(e.bytes),
                                            width: e.width * 0.93,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
        ),
      );
    }
    //
    //
    return result;
  }

  double newHeight(double height, double itemsHeight) {
    if (itemsHeight == 0 || maxColumnHeight == 0) {
      return 0;
    }

    double r = height / itemsHeight;

    if (r.isNaN || r.isInfinite) {
      return 0;
    }

    return r * ((maxColumnHeight - 50) * 0.80);
  }

  bool canAdd({
    required int index,
    required List<QuestionImageInformation> list,
    required QuestionImageInformation item,
  }) {
    //
    int sum = list.fold(0, (prev, element) => prev + element.height);
    //
    return (sum + item.height) < (maxColumnHeight - (50 + (index == 0 ? 0 : headerHeight)));
  }

  //
  Future<QuestionImageInformation> widgetToImageInformation({
    required ScreenshotController controller,
    required Rect rect,
  }) async {
    var value = await controller.capture(pixelRatio: 1);
    //
    if (value == null) {
      debugPrint("Screenshot capture failed.");
      throw Exception();
    }
    //
    final filePath = await getFilePath();
    //
    await XFile.fromData(value).saveTo(filePath);
    //
    ui.Image? image = await decodeImageFromList(value);
    // Extract the width and height of the image
    final width = image.width;
    final height = image.height;
    //
    return QuestionImageInformation(
      bytes: value,
      originalHeight: height,
      originalWidth: width,
      itemWidth: itemWidth,
    );
  }

  Future<String> getFilePath() async {
    //
    Directory? externalDir;
    //
    if (Platform.isIOS) {
      externalDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      externalDir = await getExternalStorageDirectory();
    } else {
      externalDir = await getApplicationSupportDirectory();
    }
    //
    final ts = DateTime.now().toIso8601String();
    //
    final filePath = "${externalDir!.path}/$ts.png";
    //
    return filePath;
  }

  //
  Future<void> preCashImages({
    required List<Question> questions,
    required BuildContext context,
  }) async {
    //
    for (var q in questions) {
      //
      if (q.image != null) {
        print("cached");
        await cacheImage(imageUrl: q.image!, context: context);
      }
      //
      for (var a in q.answers) {
        if (a.image != null) {
          await cacheImage(imageUrl: a.image!, context: context);
        }
      }
      //
    }
    //
  }

  //
  Future<void> cacheImage({
    required String imageUrl,
    required BuildContext context,
  }) async {
    //
    if (imageUrl.isEmpty) return;
    //
    Completer<void> completer = Completer<void>();
    //
    final imageProvider = CachedNetworkImageProvider(imageUrl);
    //
    final config = createLocalImageConfiguration(context);
    //
    final imageStream = imageProvider.resolve(config);
    //
    ImageStreamListener? listener;
    //
    listener = ImageStreamListener(
      (img, syn) {
        completer.complete();
        imageStream.removeListener(listener!);
      },
      //
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
        imageStream.removeListener(listener!);
      },
    );
    //
    imageStream.addListener(listener);
    //
    return completer.future;
  }
}
