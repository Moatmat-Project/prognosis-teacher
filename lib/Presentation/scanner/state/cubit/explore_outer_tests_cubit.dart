import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/delete_outer_test_uc.dart';

import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/delete_results_uc.dart';

import '../../../../Features/outer_tests/domain/usecases/get_outer_tests_uc.dart';

part 'explore_outer_tests_state.dart';

class ExploreOuterTestsCubit extends Cubit<ExploreOuterTestsState> {
  ExploreOuterTestsCubit() : super(ExploreOuterTestsLoading());
  List<Result> results = [];
  init() async {
    //
    emit(ExploreOuterTestsLoading());
    //
    final res = await locator<GetOuterTestsUseCase>().call();
    //
    res.fold(
      (l) {},
      (r) {
        //
        emit(ExploreOuterTestsInitial(
          tests: r,
        ));
      },
    );
    //
  }

  deleteTest(int id) async {
    //
    emit(ExploreOuterTestsLoading());
    //
    await locator<DeleteOuterTestUseCase>().call(id: id);
    //
    init();
    //
  }
}
