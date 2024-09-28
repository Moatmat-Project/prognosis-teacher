import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/get_outer_tests_uc.dart';
import 'package:moatmat_teacher/Features/scanner/domain/entities/paper.dart';
import 'package:moatmat_teacher/Features/scanner/domain/usecases/fetch_paper_uc.dart';
import 'package:moatmat_teacher/Features/scanner/domain/usecases/get_paper_data_uc.dart';
import 'package:moatmat_teacher/Features/scanner/domain/usecases/upload_results_uc.dart';
part 'scanner_views_manager_state.dart';

class ScannerViewsManagerCubit extends Cubit<ScannerViewsManagerState> {
  ScannerViewsManagerCubit() : super(ScannerViewsManagerLoading());
  //
  OuterTest? test;
  PaperData? data;
  PaperSettings? settings;
  //
  List<Paper> papers = [];
  //
  int formsCount = 1;
  //
  init() {
    emit(ScannerViewsManagerLoading());
    //
    setUp();
    //
    pickTest();
  }

  setUp() {
    //
    data = null;
    //
    settings = null;
    //
    papers = [];
    //
  }

  // set settings
  pickTest() async {
    final response = await locator<GetOuterTestsUseCase>().call();
    response.fold(
      (l) {
        emit(ScannerViewsManagerError(error: l.toString()));
      },
      (r) {
        emit(ScannerViewsManagerPickTest(
          tests: r,
        ));
      },
    );
  }

  setSettings(OuterTest test) {
    //
    this.test = test;
    //
    settings = PaperSettings(
        title: test.information.title,
        date: test.information.date,
        type: test.information.paperType,
        selections: [],
        formsCount: test.forms.length,
        answers: List.generate(
          test.forms.length,
          (index) => test.forms[index].questions.map((e) => e.trueAnswer).toList(),
        ));
    //
    emit(ScannerViewsManagerPapers(papers: papers));
  }

  //
  //

  setAnswers(List<List<int>> answers) {
    settings = settings!.copyWith(
      answers: answers,
    );
  }

  //
  showPapers() {
    emit(ScannerViewsManagerPapers(
      papers: papers,
    ));
  }

  // view
  showScanning() {
    emit(ScannerViewsManagerScanning(
      paperType: settings!.type,
    ));
  }

  //
  scanPaper(List<Uint8List> images) async {
    emit(ScannerViewsManagerLoading());
    try {
      var res = await locator<GetPaperDataUC>().call(
        idImage: images.first,
        answersImages: images.sublist(1, images.length - 1),
        type: settings!.type,
        formImage: images.last,
      );
      res.fold(
        (l) {
          emit(ScannerViewsManagerPapers(
            papers: papers,
            error: l.toString(),
          ));
        },
        (r) {
          //
          int selected = r.form.row.selected ?? 0;
          //
          if (selected + 1 > settings!.answers.length) {
            selected = 0;
          }
          //
          debugPrint("answers: ${settings!.answers}");
          debugPrint("selected: $selected");
          //
          emit(ScannerViewsManagerSetUpPaper(
            images: images,
            answers: settings!.answers[selected],
            paper: Paper(data: r, settings: settings!),
          ));
        },
      );
    } on Exception catch (e) {
      emit(ScannerViewsManagerPapers(
        papers: papers,
        error: e.toString(),
      ));
    }
  }

  addPaper(PaperData data) async {
    //
    emit(ScannerViewsManagerLoading());
    //
    final res = await locator<FetchPaperUC>().call(
      data: data,
      settings: settings!,
    );
    //
    res.fold(
      (l) {
        emit(ScannerViewsManagerPapers(
          papers: papers,
          error: l.toString(),
        ));
      },
      (r) {
        final duplicated = papers.where((p) {
          return p.data.id.userId == r.data.id.userId;
        });
        if (duplicated.isNotEmpty) {
          //
          emit(ScannerViewsManagerDuplicatedPapers(
            firstPaper: duplicated.first,
            secondPaper: r,
          ));
          //
        } else {
          //
          papers.add(r);
          //
          emit(ScannerViewsManagerPapers(
            papers: papers,
          ));
        }
      },
    );
  }

  solveDuplicated(Paper? firstPaper, Paper? secondPaper) {
    if (firstPaper != null) {
      emit(ScannerViewsManagerPapers(
        papers: papers,
      ));
    } else if (secondPaper != null) {
      papers.removeWhere((p) {
        return p.data.id.userId == secondPaper.data.id.userId;
      });
      papers.add(secondPaper);
      emit(ScannerViewsManagerPapers(
        papers: papers,
      ));
    }
  }

  uploadPapers() async {
    emit(ScannerViewsManagerLoading());
    final res = await locator<UploadResultsUC>().call(
      papers: papers,
      outerTest: test!,
    );
    res.fold(
      (l) {
        emit(ScannerViewsManagerPapers(
          papers: papers,
          error: l.toString(),
        ));
      },
      (r) {
        emit(ScannerViewsManagerUploadSucceed());
      },
    );
  }

  explorePaper(int index) {
    emit(ScannerViewsManagerExplorePaper(
      index: index,
      paper: papers[index],
    ));
  }

  removePaper(int index) {
    //
    emit(ScannerViewsManagerLoading());
    //
    papers.removeAt(index);
    //
    emit(ScannerViewsManagerPapers(
      papers: List.from(papers),
    ));
  }

  updatePaper(int index, Paper paper) async {
    //
    emit(ScannerViewsManagerLoading());
    //
    final res = await locator<FetchPaperUC>().call(
      data: paper.data,
      settings: settings!,
    );
    //
    res.fold(
      (l) {
        emit(ScannerViewsManagerPapers(
          papers: papers,
          error: l.toString(),
        ));
      },
      (r) {
        //
        papers[index] = r;
        //
        emit(ScannerViewsManagerPapers(
          papers: papers,
        ));
      },
    );
    papers[index] = paper;
    showPapers();
  }
}
