import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/errors/exceptions.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/banks/domain/entities/bank.dart';
import 'package:moatmat_teacher/Features/groups/domain/usecases/get_teacher_groups_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/entities/outer_test.dart';
import 'package:moatmat_teacher/Features/students/data/models/user_data_m.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/result.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

import '../../../../Core/injection/app_inj.dart';
import '../../../../Features/groups/domain/entities/group.dart';
import '../../../../Features/groups/domain/usecases/get_groups_uc.dart';
import '../../../../Features/students/domain/entities/test_details.dart';
import '../../../../Features/students/domain/usecases/get_repository_details_uc.dart';
import '../../../../Features/students/domain/usecases/get_repository_results_uc.dart';
import '../../../../Features/tests/domain/entities/test/test.dart';

part 'group_test_details_state.dart';

class GroupTestDetailsCubit extends Cubit<GroupTestDetailsState> {
  GroupTestDetailsCubit() : super(GroupTestDetailsLoading());
  late List<Group> groups;
  late List<Result> results;
  late RepositoryDetails details;
  Test? test;
  Bank? bank;
  OuterTest? outerTest;
  init({Test? test, Bank? bank, OuterTest? outerTest, TeacherData? teacherData}) async {
    emit(GroupTestDetailsLoading());
    //
    this.test = test;
    this.bank = bank;
    this.outerTest = outerTest;
    //
    var groupRes = await locator<GetTeacherGroupsUc>().call(teacherEmail: teacherData?.email ?? locator<TeacherData>().email);
    groupRes.fold(
      (l) {},
      (r) {
        groups = r;
        emit(GroupTestDetailsPickGroup(groups: r));
      },
    );
  }

  emitPickGroup() {
    emit(GroupTestDetailsPickGroup(groups: groups));
  }

  pickGroup(Group group) async {
    emit(GroupTestDetailsLoading());
    var resultsRes = await locator<GetRepositoryResultsUC>().call(
      test: test,
      bank: bank,
      outerTest: outerTest,
      update: false,
    );
    resultsRes.fold(
      (l) {
        emit(const GroupTestDetailsError(failure: AnonFailure()));
      },
      (r) {
        results = r;
      },
    );
    details = locator<GetRepositoryDetailsUC>().call(
      test: test,
      bank: bank,
      outerTest: outerTest,
      results: results,
      update: false,
    );
    //
    final res = group.items.map<(Result?, UserData)>((e) {
      if (results.map((e) => e.userId).contains(e.userData.uuid)) {
        //
        final list = results.where((r) => r.userId == e.userData.uuid).toList();
        list.sort((a, b) => b.mark.compareTo(a.mark));
        return (list.firstOrNull, e.userData);
        //
      }
      return (null, e.userData);
    }).toList();
    //
    res.sort((a, b) {
      if (a.$1 == null && b.$1 == null) {
        return 0;
      } else if (a.$1 == null) {
        return -1;
      } else if (b.$1 == null) {
        return 1;
      }
      return 0;
    });
    emit(GroupTestDetailsInitial(
      test: test,
      outerTest: outerTest,
      bank: bank,
      results: res,
      details: details,
    ));
  }
}
