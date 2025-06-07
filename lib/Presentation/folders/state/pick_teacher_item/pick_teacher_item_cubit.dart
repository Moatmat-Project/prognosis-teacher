import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../Core/errors/exceptions.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/folders_system_s.dart';
import '../../../../Features/auth/domain/entites/teacher_data.dart';
import '../../../../Features/auth/domain/use_cases/get_teacher_data.dart';
import '../../../../Features/auth/domain/use_cases/update_teacher_data_uc.dart';
import '../../../../Features/banks/domain/entities/bank.dart';
import '../../../../Features/banks/domain/usecases/get_banks_by_ids_uc.dart';
import '../../../../Features/tests/domain/entities/test/test.dart';
import '../../../../Features/tests/domain/usecases/get_tests_by_ids_uc.dart';

part 'pick_teacher_item_state.dart';

class PickTeacherItemCubit extends Cubit<PickTeacherItemState> {
  PickTeacherItemCubit() : super(const PickTeacherItemState());

  ///
  late TeacherData teacherData;

  ///
  late bool isTest;

  ///
  late FoldersSystemService foldersSystemService;

  ///
  init({
    required String teacher,
    required bool isTest,
    TeacherData? customTeacherData,
  }) async {
    ///
    final teacherDataCompleter = Completer<TeacherData>();

    ///
    this.isTest = isTest;

    ///
    emit(state.copyWith(
      teacher: "...",
      isLoading: true,
      folders: [],
      tests: [],
      banks: [],
      canPop: false,
      error: null,
    ));

    if (customTeacherData == null) {
      ///
      final teacherDataResponse = await locator<GetTeacherDataUC>().call(email: teacher);

      ///
      teacherDataResponse.fold(
        (l) {
          emit(state.copyWith(error: AnonFailure()));
        },
        (r) async {
          teacherDataCompleter.complete(r);
        },
      );
    } else {
      teacherDataCompleter.complete(customTeacherData);
    }

    ///
    teacherData = await teacherDataCompleter.future;

    ///
    foldersSystemService = FoldersSystemService(
      directories: isTest ? teacherData.testsFolders : teacherData.banksFolders,
      onUpdate: (data) async {
        if (isTest) {
          await locator<UpdateTeacherDataUC>().call(
            teacherData: teacherData.copyWith(
              testsFolders: data,
            ),
          );
        } else {
          await locator<UpdateTeacherDataUC>().call(
            teacherData: teacherData.copyWith(
              banksFolders: data,
            ),
          );
        }
      },
    );

    ///
    emit(state.copyWith(
      isLoading: false,
      canPop: foldersSystemService.canPop,
      teacher: teacherData.name,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  List<String> listAllDirectories() {
    return foldersSystemService.listAllDirectories();
  }

  ///
  exploreDirectory(String directory) async {
    //
    emit(state.copyWith(isLoading: true));
    //
    foldersSystemService.path = directory;
    //
    emit(state.copyWith(
      isLoading: false,
      canPop: foldersSystemService.canPop,
      teacher: teacherData.name,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  exploreFolder(String folder) async {
    //
    emit(state.copyWith(isLoading: true));
    //
    foldersSystemService.pushPathForward(directory: folder);
    //
    emit(state.copyWith(
      isLoading: false,
      canPop: foldersSystemService.canPop,
      teacher: teacherData.name,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  ///
  void backDirectory() async {
    //
    emit(state.copyWith(isLoading: true));
    //
    foldersSystemService.popPathBack();
    //
    emit(state.copyWith(
      isLoading: false,
      canPop: foldersSystemService.canPop,
      teacher: teacherData.name,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
    ));
  }

  ///
  ///
  Future<List<Bank>> getBanks(List<int> ids) async {
    List<Bank> banks = [];
    //
    var res = await locator<GetBanksByIdsUC>().call(ids: ids, update: true);
    //
    res.fold(
      (l) {},
      (r) {
        banks = r;
      },
    );
    //
    return banks;
  }

  //
  Future<List<Test>> getTests(List<int> ids) async {
    //
    List<Test> tests = [];
    //
    var res = await locator<GetTestsByIdsUC>().call(ids: ids, update: true);
    //
    res.fold(
      (l) {},
      (r) {
        tests = r;
      },
    );
    //
    return tests;
  }
}
