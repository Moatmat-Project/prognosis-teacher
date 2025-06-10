import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_my_students_uc.dart';

part 'my_students_state.dart';

class MyStudentsCubit extends Cubit<MyStudentsState> {
  MyStudentsCubit() : super(MyStudentsLoading());

  List<UserData> users = [];
  List<int> testsIds = [];

  init() async {
    //
    emit(MyStudentsLoading());
    //
    var res = await locator<GetMyStudentsUC>().call();
    //
    res.fold(
      (l) {
        emit(MyStudentsError(error: l.toString()));
      },
      (r) {
        users = r.students;
        testsIds = r.testsIds;
        emit(MyStudentsInitial(users: r.students, testsIds: r.testsIds));
      },
    );
  }

  update() async {
    //
    emit(MyStudentsLoading());
    //
    var res = await locator<GetMyStudentsUC>().call();
    //
    res.fold(
      (l) => emit(MyStudentsError(error: l.toString())),
      (r) {
        users = r.students;
        testsIds = r.testsIds;
        emit(MyStudentsInitial(users: r.students, testsIds: r.testsIds));
      },
    );
  }

  search(String key) {
    emit(
      MyStudentsInitial(
        users: users.where((e) => e.name.contains(key) || key.isEmpty).toList(),
        testsIds: testsIds,
      ),
    );
  }
}
