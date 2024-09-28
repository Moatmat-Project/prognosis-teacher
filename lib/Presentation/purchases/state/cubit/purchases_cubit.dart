import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/purchase/domain/entities/purchase_item.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/purchase/domain/usecases/teacher_purchases_uc.dart';

part 'purchases_state.dart';

class PurchasesCubit extends Cubit<PurchasesState> {
  PurchasesCubit() : super(PurchasesLoading());

  init() async {
    //
    emit(PurchasesLoading());
    //
    var res = await locator<TeacherPurchasesUC>().call(
      email: locator<TeacherData>().email,
    );
    //
    res.fold(
      (l) {
        emit(PurchasesInitial(error: l.toString(), purchases: const []));
      },
      (r) {
        emit(PurchasesInitial(purchases: r));
      },
    );
  }
}
