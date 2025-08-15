import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/purchase/domain/entities/purchase_item.dart';
import 'package:moatmat_teacher/Features/purchase/domain/usecases/test_purchases_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_test_by_id_uc.dart';

part 'test_information_state.dart';

class TestInformationCubit extends Cubit<TestInformationState> {
  TestInformationCubit() : super(TestInformationLoading());
  Test? test;
  init({int? testId}) async {
    //
    emit(TestInformationLoading());
    //
    var res1 = await locator<GetTestByIdUC>().call(
      testId: testId!,
      update: true,
    );
    //
    res1.fold(
      (l) => null,
      (r) {
        test = r;
      },
    );
    //
    if (test != null) {
      var res2 = await locator<TestPurchasesUC>().call(test: test!);
      //
      res2.fold(
        (l) => emit(TestInformationError(message: l.toString())),
        (r) {
          emit(
            TestInformationInitial(
              test: test!,
              items: r,
            ),
          );
        },
      );
    } else {
      // print(testId);
      emit(const TestInformationError(message: "لم يتم العثور على الاختبار"));
    }
  }
}
