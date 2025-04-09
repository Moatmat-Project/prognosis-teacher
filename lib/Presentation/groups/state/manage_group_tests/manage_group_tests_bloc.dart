import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moatmat_teacher/Features/groups/domain/entities/group.dart';
import 'package:moatmat_teacher/Features/groups/domain/usecases/set_group_tests_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import '../../../../Core/injection/app_inj.dart';
import '../../../../Core/services/folders_system_s.dart';
import '../../../../Features/auth/domain/entites/teacher_data.dart';
import '../../../../Features/tests/domain/usecases/get_tests_by_ids_uc.dart';

part 'manage_group_tests_event.dart';
part 'manage_group_tests_state.dart';

class ManageGroupTestsBloc extends Bloc<ManageGroupTestsEvent, ManageGroupTestsState> {
  ///
  final GetTestsByIdsUC _getTestsByIdsUC;
  final SetGroupTestsUC _setGroupTestsUC;

  ///
  late FoldersSystemService foldersSystemService;

  ///
  Group? group;
  bool isCourseSubscribersGroup = false;

  ///
  ManageGroupTestsBloc(this._getTestsByIdsUC, this._setGroupTestsUC) : super(ManageGroupTestsLoading()) {
    on<ManageGroupTestsLoadEvent>(onManageGroupTestsLoadEvent);
    on<ManageGroupTestsStartPickTestEvent>(onManageGroupTestsStartPickTestEvent);
    on<ManageGroupTestsAddTestEvent>(onManageGroupTestsAddTestEvent);
    on<ManageGroupTestsRemoveTestEvent>(onManageGroupTestsRemoveTestEvent);
    on<ManageGroupTestsOpenFolderEvent>(onManageGroupTestsOpenFolderEvent);
    on<ManageGroupTestsOpenDirectoryEvent>(onManageGroupTestsOpenDirectoryEvent);
    on<ManageGroupTestsPopBackEvent>(onManageGroupTestsPopBackEvent);
    on<ManageGroupTestsSaveChangesEvent>(onManageGroupTestsSaveChangesEvent);
  }
  //
  onManageGroupTestsSaveChangesEvent(ManageGroupTestsSaveChangesEvent event, Emitter<ManageGroupTestsState> emit) async {
    //
    emit(ManageGroupTestsInitial(selectedTests: state.selectedTests, canSaving: true, isLoading: true));
    //
    Either<Exception, Unit> response;
    //
    response = await _setGroupTestsUC.call(
      groupId: group?.id ?? 0,
      testsIds: state.selectedTests.map((e) => e.id).toList(),
      isCourseSubscribersGroup: isCourseSubscribersGroup,
    );
    //
    response.fold(
      (l) {
        Fluttertoast.showToast(msg: l.toString());
        emit(ManageGroupTestsInitial(selectedTests: state.selectedTests, canSaving: false, isLoading: false));
      },
      (r) {
        Fluttertoast.showToast(msg: "تم الحفظ بنجاح");
        emit(ManageGroupTestsInitial(selectedTests: state.selectedTests, canSaving: false, isLoading: false));
      },
    );
  }

  //
  onManageGroupTestsLoadEvent(ManageGroupTestsLoadEvent event, Emitter<ManageGroupTestsState> emit) async {
    emit(ManageGroupTestsLoading());

    isCourseSubscribersGroup = event.isCourseSubscribersGroup;
    if (isCourseSubscribersGroup) {
      emit(ManageGroupTestsInitial(
        selectedTests: await getTests(locator<TeacherData>().courseSubscribersTests),
        canSaving: state.canSaving,
      ));
    } else {
      group = locator<TeacherData>().groups.firstWhere((element) => element.id == event.group.id);
      emit(ManageGroupTestsInitial(
        selectedTests: await getTests(group!.testsIds),
        canSaving: state.canSaving,
      ));
    }
  }

  //
  onManageGroupTestsStartPickTestEvent(ManageGroupTestsStartPickTestEvent event, Emitter<ManageGroupTestsState> emit) async {
    //
    emit(ManageGroupTestsPickTests(
      isLoading: true,
      canSaving: state.canSaving,
    ));
    //
    foldersSystemService = FoldersSystemService(
      directories: locator<TeacherData>().testsFolders,
      onUpdate: (directories) {},
    );

    //
    emit(ManageGroupTestsPickTests(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: await getTests(foldersSystemService.getDirectoryItems()),
      selectedTests: state.selectedTests,
      isLoading: false,
      canSaving: state.canSaving,
    ));
  }

  //
  onManageGroupTestsAddTestEvent(ManageGroupTestsAddTestEvent event, Emitter<ManageGroupTestsState> emit) async {
    emit(
      ManageGroupTestsPickTests(
        canPop: foldersSystemService.canPop,
        folders: foldersSystemService.getSubdirectories(),
        tests: (state as ManageGroupTestsPickTests).tests,
        selectedTests: List.from(state.selectedTests)..add(event.test),
        isLoading: false,
        canSaving: true,
      ),
    );
  }

  //
  onManageGroupTestsRemoveTestEvent(ManageGroupTestsRemoveTestEvent event, Emitter<ManageGroupTestsState> emit) async {
    if (state is ManageGroupTestsInitial) {
      emit(ManageGroupTestsInitial(
        selectedTests: List.from(state.selectedTests)..remove(event.test),
        canSaving: true,
      ));
    }
    if (state is ManageGroupTestsPickTests) {
      emit(ManageGroupTestsPickTests(
        canPop: foldersSystemService.canPop,
        folders: foldersSystemService.getSubdirectories(),
        tests: (state as ManageGroupTestsPickTests).tests,
        selectedTests: List.from(state.selectedTests)..remove(event.test),
        isLoading: false,
        canSaving: true,
      ));
    }
  }

  //
  onManageGroupTestsOpenFolderEvent(ManageGroupTestsOpenFolderEvent event, Emitter<ManageGroupTestsState> emit) async {
    //
    emit(ManageGroupTestsPickTests(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: (state as ManageGroupTestsPickTests).tests,
      selectedTests: state.selectedTests,
      isLoading: true,
      canSaving: state.canSaving,
    ));
    //
    foldersSystemService.pushPathForward(directory: event.folder);
    //
    emit(ManageGroupTestsPickTests(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: await getTests(foldersSystemService.getDirectoryItems()),
      selectedTests: state.selectedTests,
      isLoading: false,
      canSaving: state.canSaving,
    ));
  }

  //
  onManageGroupTestsOpenDirectoryEvent(ManageGroupTestsOpenDirectoryEvent event, Emitter<ManageGroupTestsState> emit) async {
    //
    emit(ManageGroupTestsPickTests(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: (state as ManageGroupTestsPickTests).tests,
      selectedTests: state.selectedTests,
      isLoading: true,
      canSaving: state.canSaving,
    ));
    //
    foldersSystemService.path = event.directory;
    //
    emit(ManageGroupTestsPickTests(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: await getTests(foldersSystemService.getDirectoryItems()),
      selectedTests: state.selectedTests,
      isLoading: false,
      canSaving: state.canSaving,
    ));
  }

  //
  onManageGroupTestsPopBackEvent(ManageGroupTestsPopBackEvent event, Emitter<ManageGroupTestsState> emit) async {
    //
    emit(ManageGroupTestsPickTests(
      canPop: foldersSystemService.canPop,
      folders: foldersSystemService.getSubdirectories(),
      tests: (state as ManageGroupTestsPickTests).tests,
      selectedTests: state.selectedTests,
      isLoading: true,
      canSaving: state.canSaving,
    ));
    //
    if (foldersSystemService.canPop) {
      //
      foldersSystemService.popPathBack();
      //
      emit(ManageGroupTestsPickTests(
        canPop: foldersSystemService.canPop,
        folders: foldersSystemService.getSubdirectories(),
        tests: await getTests(foldersSystemService.getDirectoryItems()),
        selectedTests: state.selectedTests,
        isLoading: false,
        canSaving: state.canSaving,
      ));
    } else {
      emit(
        ManageGroupTestsInitial(
          selectedTests: state.selectedTests,
          canSaving: state.canSaving,
        ),
      );
    }
  }

  List<String> listAllDirectories() {
    return foldersSystemService.listAllDirectories();
  }

  //
  Future<List<Test>> getTests(List<int> ids) async {
    //
    List<Test> tests = [];
    //
    var res = await _getTestsByIdsUC.call(ids: ids, update: true);
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
