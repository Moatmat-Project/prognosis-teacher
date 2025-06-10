import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/delete_test_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_my_tests_uc.dart';

part 'my_tests_state.dart';

class MyTestsCubit extends Cubit<MyTestsState> {
  MyTestsCubit() : super(MyTestsLoading());
  //
  init() async {
    emit(MyTestsLoading());
    var res = await locator<GetMyTestsUC>().call(update: false);
    res.fold(
      (l) => emit(MyTestsError(exception: l)),
      (r) => emit(MyTestsInitial(tests: List.from(r))),
    );
  }

  update() async {
    emit(MyTestsLoading());
    var res = await locator<GetMyTestsUC>().call(update: true);
    res.fold(
      (l) => emit(MyTestsError(exception: l)),
      (r) => emit(MyTestsInitial(tests: List.from(r))),
    );
  }

  Future<void> deleteTest(Test test) async {
    var res = await locator<DeleteTestsUC>().call(testId: test.id);
    res.fold(
      (l) => emit(MyTestsError(exception: l)),
      (r) => update(),
    );
    return;
  }
}
