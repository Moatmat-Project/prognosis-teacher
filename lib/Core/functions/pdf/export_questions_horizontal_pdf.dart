import '../../../Presentation/export/other/export_test_options.dart';
import '../../../Presentation/export/other/question_image_information.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:pdf/widgets.dart';

import '../../widgets/pdf/footer_w.dart';
import '../../widgets/pdf/header_w.dart';

double get horizontalPadding => 25;
double get verticalPadding => 5;
double get headerHeight => 34;
double get footerHeight => 20;
double get availablePageHeight => PdfPageFormat.a4.height - (headerHeight + footerHeight + (verticalPadding * 2));
double get maxColumnHeight => availablePageHeight;
double get itemWidth => PdfPageFormat.a4.width - (horizontalPadding * 2);
Future<String> exportQuestionsHorizontalPdf({
  required List<QuestionImageInformation> images,
  required ExportTestOptions exportTestOptions,
  required String title,
  required String form,
}) async {
  // updating image ratio to fit in pdf size ratio
  for (int i = 0; i < images.length; i++) {
    images[i] = QuestionImageInformation.fromClass(
      image: images[i],
      newWidth: itemWidth.toInt(),
    );
  }

  // //
  // images.shuffle();
  //
  final pdf = pw.Document();
  //
  var base = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Arial/arial.ttf"),
  );
  var bold = pw.Font.ttf(
    await rootBundle.load("assets/fonts/Arial/arial-bold.ttf"),
  );

  ///
  List<pw.Page> pages = await getPages(
    images: images,
    exportTestOptions: exportTestOptions,
    title: title,
    form: form,
    base: base,
    bold: bold,
  );

  ///
  for (var r in pages) {
    pdf.addPage(r);
  }

  // Save the PDF file to local storage
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/results_of_${title}_$form.pdf');
  final File pdfFile = await file.writeAsBytes(await pdf.save());

  return pdfFile.path;
}

Future<List<pw.Page>> getPages({
  required List<QuestionImageInformation> images,
  required ExportTestOptions exportTestOptions,
  required String title,
  required String form,
  required Font? base,
  required Font? bold,
}) async {
  MemoryImage? watermarkImage;
  List<pw.Page> pages = [];
  List<List<QuestionImageInformation>> pagesImagesHolder = [[]];
  //
  if (exportTestOptions.waterMark != null) {
    watermarkImage = pw.MemoryImage(await File(exportTestOptions.waterMark!).readAsBytes());
  }
  //
  for (int i = 0; i < images.length; i++) {
    final currentImage = images[i];
    final currentHeight = pagesImagesHolder.last.fold(0.0, (prev, img) => prev + img.height);
    double allowedHeight = maxColumnHeight;
    if (pagesImagesHolder.length > 1) {
      allowedHeight = maxColumnHeight + (headerHeight);
    }
    if ((currentHeight + currentImage.height) >= allowedHeight) {
      pagesImagesHolder.add([]);
    }
    pagesImagesHolder.last.add(currentImage);
  }
  //
  for (int i = 0; i < pagesImagesHolder.length; i++) {
    pages.add(
      getPage(
        index: i,
        images: pagesImagesHolder[i],
        exportTestOptions: exportTestOptions,
        title: title,
        form: form,
        base: base,
        bold: bold,
        watermarkImage: watermarkImage,
      ),
    );
  }
  return pages;
}

pw.Page getPage({
  required int index,
  required List<QuestionImageInformation> images,
  required ExportTestOptions exportTestOptions,
  required String title,
  required String form,
  required Font? base,
  required Font? bold,
  MemoryImage? watermarkImage,
}) {
  return pw.Page(
    pageTheme: pw.PageTheme(
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
      ),
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
    ),
    build: (context) {
      return pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          if (index == 0)
            getHeader(
              headerHeight: headerHeight,
              title: title,
              email: exportTestOptions.email,
              form: form,
              minutes: exportTestOptions.minutes,
            ),
          pw.Stack(
            alignment: pw.Alignment.center,
            children: [
              //
              if (watermarkImage != null)
                pw.Positioned.fill(
                  child: pw.Center(
                    child: pw.Transform.rotate(
                      angle: -0.5,
                      child: pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Opacity(
                          opacity: 0.2,
                          child: pw.Image(
                            watermarkImage,
                            width: itemWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              pw.Container(
                height: availablePageHeight,
                child: pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      ...images.map(
                        (e) => pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Image(
                              pw.MemoryImage(e.bytes),
                              width: e.width.toDouble(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          getFooter(
            isLastPage: context.pageNumber == context.pagesCount,
            footerHeight: footerHeight,
            pageNumber: context.pageNumber,
            pagesCount: context.pagesCount,
          )
        ],
      );
    },
  );
}
