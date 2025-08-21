import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/purchase/domain/entities/purchase_item.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/purchase/domain/usecases/teacher_purchases_uc.dart';

part 'purchases_state.dart';

class PurchasesCubit extends Cubit<PurchasesInitial> {
  PurchasesCubit() : super(PurchasesInitial(purchases: [], filtered: [], isLoading: false));

  init() async {
    //
    emit(state.copyWith(isLoading: true));
    //
    var res = await locator<TeacherPurchasesUC>().call(
      email: locator<TeacherData>().email,
    );
    //
    res.fold(
      (l) {
        DateTime now = DateTime.now();
        emit(state.copyWith(
          isLoading: false,
          error: l.toString(),
          purchases: [],
          filtered: [],
          starting: DateTime(now.year, 1, 1),
          ending: DateTime(now.year, 12, 31),
        ));
      },
      (r) {
        emit(state.copyWith(
          isLoading: false,
          purchases: r,
          starting: _parseMMDDToCurrentYear(r.last.dayAndMoth),
          ending: _parseMMDDToCurrentYear(r.first.dayAndMoth),
          filtered: r,
          error: null,
        ));
      },
    );
  }

  changeTime({DateTime? starting, DateTime? ending}) {
    final newStarting = starting ?? state.starting!;
    final newEnding = ending ?? state.ending!;
    //
    final filtered = state.purchases.where((p) {
      final d = _parseMMDDToCurrentYear(p.dayAndMoth);
      return !d.isBefore(newStarting) && !d.isAfter(newEnding);
    }).toList();
    //
    emit(state.copyWith(
      isLoading: false,
      starting: newStarting,
      ending: newEnding,
      filtered: filtered,
    ));
  }

  DateTime _parseMMDDToCurrentYear(String mmdd) {
    final now = DateTime.now();
    final parsed = DateFormat('MM/dd').parse(mmdd);
    return DateTime(now.year, parsed.month, parsed.day);
  }
}
