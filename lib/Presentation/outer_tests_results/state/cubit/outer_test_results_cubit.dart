import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/test_details.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_repository_details_uc.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_repository_results_uc.dart';

part 'outer_test_results_state.dart';

class OuterTestResultsCubit extends Cubit<OuterTestResultsState> {
  OuterTestResultsCubit() : super(const OuterTestResultsLoading());
  OuterTest? test;
  init(OuterTest test) async {
    //
    this.test = test;
    //
    emit(const OuterTestResultsLoading());
    //
    var res = await locator<GetRepositoryResultsUC>().call(
      outerTest: test,
      bank: null,
      update: false,
      test: null,
    );
    //
    res.fold(
      (l) => emit(OuterTestResultsError(l.toString())),
      (r) async {
        //
        var details = locator<GetRepositoryDetailsUC>().call(
          outerTest: test,
          bank: null,
          test: null,
          results: r,
          update: false,
        );
        //
        emit(OuterTestResultsInitial(details: details));
      },
    );
  }

  update() async {
    //
    emit(const OuterTestResultsLoading());
    //
    var res = await locator<GetRepositoryResultsUC>().call(
      outerTest: test!,
      bank: null,
      test: null,
      update: true,
    );
    //
    res.fold(
      (l) => emit(OuterTestResultsError(l.toString())),
      (r) {
        //
        var details = locator<GetRepositoryDetailsUC>().call(
          bank: null,
          outerTest: test,
          results: r,
          update: true,
          test: null,
        );
        //
        emit(OuterTestResultsInitial(details: details));
      },
    );
  }
}
