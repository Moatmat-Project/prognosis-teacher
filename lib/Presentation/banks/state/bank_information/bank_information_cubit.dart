import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/get_bank_by_id_uc.dart';
import 'package:moatmat_teacher/Features/purchase/domain/usecases/bank_purchases_uc.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/purchase/domain/entities/purchase_item.dart';

part 'bank_information_state.dart';

class BankInformationCubit extends Cubit<BankInformationState> {
  BankInformationCubit() : super(BankInformationLoading());

  init({Bank? bank, int? bankId}) async {
    //
    emit(BankInformationLoading());
    //
    if (bank == null) {
      //
      var res1 = await locator<GetBankByIdUC>().call(
        bankId: bankId!,
        update: true,
      );
      //
      res1.fold(
        (l) => null,
        (r) {
          bank = r;
        },
      );
    }
    //
    if (bank != null) {
      var res2 = await locator<BankPurchasesUC>().call(bank: bank!);
      //
      res2.fold(
        (l) => emit(BankInformationError(message: l.toString())),
        (r) {
          emit(
            BankInformationInitial(
              bank: bank!,
              items: r,
            ),
          );
        },
      );
    } else {
      emit(const BankInformationError(message: "لم يتم العثور على البنك"));
    }
  }
}
