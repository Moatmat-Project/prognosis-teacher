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
  List<UserData> selectedUsers = [];

  init() async {
    //
    emit(MyStudentsLoading());
    users = [];
    testsIds = [];
    selectedUsers = [];
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
        emit(MyStudentsInitial(users: r.students, testsIds: r.testsIds, selectedUsers: []));
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
        emit(MyStudentsInitial(
          users: r.students,
          testsIds: r.testsIds,
          selectedUsers: [],
        ));
      },
    );
  }

  search(String key) {
    emit(
      MyStudentsInitial(
        users: users.where((e) => e.name.contains(key) || key.isEmpty).toList(),
        testsIds: testsIds,
        selectedUsers: selectedUsers,
      ),
    );
  }

  void toggleSelection(UserData user) {
    if (selectedUsers.any((u) => u.id == user.id)) {
      selectedUsers.removeWhere((u) => u.id == user.id);
    } else {
      selectedUsers.add(user);
    }
    emit(MyStudentsInitial(users: users, testsIds: testsIds, selectedUsers: selectedUsers));
  }

  List<UserData> get getSelectedUsers => selectedUsers;

  bool isSelected(UserData user) {
    return selectedUsers.any((u) => u.id == user.id);
  }
}
