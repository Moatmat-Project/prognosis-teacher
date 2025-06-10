import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Core/services/folders_system_s.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_tests_by_ids_uc.dart';

import '../../../../Features/banks/domain/usecases/get_banks_by_ids_uc.dart';

part 'folders_manager_state.dart';

class FoldersManagerCubit extends Cubit<FoldersManagerState> {
  FoldersManagerCubit() : super(const FoldersManagerState());

  ///
  late bool isTest;

  ///
  late FoldersSystemService foldersSystemService;

  ///
  init(bool isTest) async {
    //
    this.isTest = isTest;
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    if (isTest) {
      foldersSystemService = FoldersSystemService(
        onUpdate: (directories) {
          locator<TeacherData>().updateTestsFolders(deepCopy(directories));
        },
        directories: deepCopy(locator<TeacherData>().testsFolders),
      );
    } else {
      foldersSystemService = FoldersSystemService(
        onUpdate: (directories) {
          locator<TeacherData>().updateBanksFolders(deepCopy(directories));
        },
        directories: deepCopy(locator<TeacherData>().banksFolders),
      );
    }

    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  ///
  exploreFolder(String folder) async {
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    foldersSystemService.pushPathForward(directory: folder);
    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  exploreDirectory(String directory) async {
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    foldersSystemService.path = directory;
    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  popBack() async {
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    foldersSystemService.popPathBack();
    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  List<String> listAllDirectories() {
    return foldersSystemService.listAllDirectories();
  }

  ///
  createDirectory(String title) async {
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    foldersSystemService.createDirectory(directory: title);
    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  deleteDirectory(String name) async {
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    foldersSystemService.removeDirectory(directory: name);
    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  addItem(int item) async {
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    foldersSystemService.addItemDirectory(item: item);
    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  removeItem(int item) async {
    //
    emit(const FoldersManagerState(isLoading: true));
    //
    foldersSystemService.removeItemDirectory(item: item);
    //
    emit(FoldersManagerState(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: isTest ? await getTests(foldersSystemService.getDirectoryItems()) : [],
      banks: !isTest ? await getBanks(foldersSystemService.getDirectoryItems()) : const [],
      isLoading: false,
    ));
  }

  //
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

Map<String, dynamic> deepCopy(Map<String, dynamic> original) {
  return jsonDecode(jsonEncode(original)) as Map<String, dynamic>;
}
