import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/delete_bank_uc.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/get_my_banks_uc.dart';

import '../../../../Core/injection/app_inj.dart';

part 'my_banks_state.dart';

class MyBanksCubit extends Cubit<MyBanksState> {
  MyBanksCubit() : super(MyBanksLoading());
  init() async {
    emit(MyBanksLoading());
    var res = await locator<GetMyBanksUC>().call(update: false);
    res.fold(
      (l) => emit(MyBanksError(exception: l)),
      (r) => emit(MyBanksInitial(banks: List.from(r))),
    );
  }

  update() async {
    emit(MyBanksLoading());
    var res = await locator<GetMyBanksUC>().call(update: true);
    res.fold(
      (l) => emit(MyBanksError(exception: l)),
      (r) => emit(MyBanksInitial(banks: List.from(r))),
    );
  }

  Future<void> deleteBank(Bank bank) async {
    var res = await locator<DeleteBankUC>().call(bankId: bank.id);
    res.fold(
      (l) => emit(MyBanksError(exception: l)),
      (r) => update(),
    );
    return;
  }
}
