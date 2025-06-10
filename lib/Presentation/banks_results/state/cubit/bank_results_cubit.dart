import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/test_details.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_repository_details_uc.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_repository_results_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/question/question.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

part 'bank_results_state.dart';

class BankResultsCubit extends Cubit<BankResultsState> {
  BankResultsCubit() : super(const BankResultsLoading());
  Bank? bank;
  init(Bank bank) async {
    //
    this.bank = bank;
    //
    emit(const BankResultsLoading());
    //
    var res = await locator<GetRepositoryResultsUC>().call(
      bank: bank,
      test: null,
      outerTest: null,
      update: false,
    );
    //
    res.fold(
      (l) => emit(BankResultsError(l.toString())),
      (r) {
        //
        var details = locator<GetRepositoryDetailsUC>().call(
          test: null,
          bank: bank,
          outerTest: null,
          results: r,
          update: false,
        );
        //
        emit(BankResultsInitial(details: details));
      },
    );
  }

  update() async {
    //
    emit(const BankResultsLoading());
    //
    var res = await locator<GetRepositoryResultsUC>().call(
      bank: bank!,
      test: null,
      outerTest: null,
      update: true,
    );
    //
    res.fold(
      (l) => emit(BankResultsError(l.toString())),
      (r) {
        //
        var details = locator<GetRepositoryDetailsUC>().call(
          bank: bank!,
          test: null,
          outerTest: null,
          results: r,
          update: true,
        );
        //
        emit(BankResultsInitial(details: details));
      },
    );
  }
}
