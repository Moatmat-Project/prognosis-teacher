import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_my_students_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/entities/test/test.dart';

part 'my_students_state.dart';

class MyStudentsCubit extends Cubit<MyStudentsState> {
  MyStudentsCubit() : super(MyStudentsLoading());

  List<UserData> users = [];

  init() async {
    //
    emit(MyStudentsLoading());
    //
    var res = await locator<GetMyStudentsUC>().call(update: false);
    //
    res.fold(
      (l) {
        emit(MyStudentsError(error: l.toString()));
      },
      (r) {
        users = r;
        emit(MyStudentsInitial(users: r));
      },
    );
  }

  update() async {
    //
    emit(MyStudentsLoading());
    //
    var res = await locator<GetMyStudentsUC>().call(update: true);
    //
    res.fold(
      (l) => emit(MyStudentsError(error: l.toString())),
      (r) {
        users = r;
        emit(MyStudentsInitial(users: r));
      },
    );
  }

  search(String key) {
    emit(
      MyStudentsInitial(
        users: users.where((e) => e.name.contains(key) || key.isEmpty).toList(),
      ),
    );
  }
}
