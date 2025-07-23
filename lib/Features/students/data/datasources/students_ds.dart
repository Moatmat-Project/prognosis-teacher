import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/attendance/data/models/attendance_record_model.dart';
import 'package:moatmat_teacher/Features/auth/domain/entites/teacher_data.dart';
import 'package:moatmat_teacher/Features/auth/domain/use_cases/get_users_data_by_ids.dart';
import 'package:moatmat_teacher/Features/banks/domain/usecases/get_bank_by_id_uc.dart';
import 'package:moatmat_teacher/Features/outer_tests/domain/usecases/get_outer_test_by_id_uc.dart';
import 'package:moatmat_teacher/Features/students/data/models/result_m.dart';
import 'package:moatmat_teacher/Features/students/data/models/user_data_m.dart';
import 'package:moatmat_teacher/Features/students/domain/usecases/get_repository_details_uc.dart';
import 'package:moatmat_teacher/Features/tests/domain/usecases/get_test_by_id_uc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../banks/domain/entities/bank.dart';
import '../../../outer_tests/domain/entities/outer_test.dart';
import '../../../tests/domain/entities/test/test.dart';
import '../../domain/entities/result.dart';
import '../../domain/entities/user_data.dart';
import '../responses/get_my_students_response.dart';
import '../responses/get_my_students_statistics_response.dart';

abstract class StudentsDS {
  //
  // get my students
  Future<GetMyStudentsResponse> getMyStudents({
    required bool excludeCourseSubscribers,
    required bool excludeBanks,
    required bool excludeTests,
  });
  //
  Future<GetMyStudentsStatisticsResponse> getMyStudentsStatistics({
    required List<UserData> students,
  });
  // get my students
  Future<List<UserData>> getMyStudentsByIds({
    required List<String> ids,
  });
  // get my students
  Future<List<UserData>> getRepositoryStudents({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  });
  //
  // search in my students
  Future<List<UserData>> searchInMyStudents({
    required String text,
    required bool update,
  });
  //
  // get student results
  Future<List<Result>> getStudentResults({
    required String id,
    required bool update,
  });
  //
  // get test results
  Future<List<Result>> getRepositoryResults({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  });
  // delete test results
  Future<Unit> deleteRepositoryResults({
    required List<int>? results,
    int? testId,
    int? bankId,
    int? outerTestId,
  });
  //
  Future<double> getRepositoryAverage({
    required String? testId,
    required String? bankId,
    required String? outerTestId,
    required bool update,
  });
  Future<Unit> addResults({
    required List<Result> results,
  });

  //
}

class StudentsDSimpl implements StudentsDS {
  const StudentsDSimpl();

  @override
  Future<List<UserData>> getRepositoryStudents({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    // get result using tests ids
    final List<Map> myResultsData;
    //
    if (test != null) {
      myResultsData = await client.from("results").select().eq("test_id", test.id).order("id");
    } else if (outerTest != null) {
      myResultsData = await client.from("results").select().eq("outer_test_id", outerTest.id).order("id");
    } else {
      myResultsData = await client.from("results").select().eq("bank_id", bank!.id).order("id");
    }
    //
    // getting users ids
    final List<Map> myUsers;
    //
    myUsers = await client.from("users_data").select().inFilter("uuid", myResultsData.map((e) => e["user_id"]).toList());
    //
    return myUsers.map((e) => UserDataModel.fromJson(e)).toList();
  }

  @override
  Future<GetMyStudentsResponse> getMyStudents({
    bool excludeCourseSubscribers = false,
    bool excludeBanks = false,
    bool excludeTests = false,
  }) async {
    //
    // final client = client;
    final client = Supabase.instance.client;

    //
    final teacherData = locator<TeacherData>();
    //
    // get my tests ids
    final List<Map> myTestsIds;
    //
    final List<Map> myBanksIds;
    //
    myTestsIds = excludeTests ? [] : await client.from("tests").select("id").eq("teacher_email", teacherData.email).order("id");
    //
    myBanksIds = excludeBanks ? [] : await client.from("banks").select("id").eq("teacher_email", teacherData.email).order("id");
    //
    // get result using tests ids
    final List<Map> myResults;
    final List<Map> myPurchases;
    //
    List<int> testsIds = myTestsIds.map((e) => e["id"] as int).toList();
    //
    List<int> banksIds = myBanksIds.map((e) => e["id"] as int).toList();
    //
    final String cod1, cod2, cod3;
    //
    cod1 = "test_id.in.(${testsIds.join(',')})";
    //
    cod2 = "bank_id.in.(${banksIds.join(',')})";
    //
    cod3 = "teacher_email.eq.${locator<TeacherData>().email}";
    //
    if (!excludeBanks || !excludeTests) {
      myResults = await client.from("results").select("user_id").or(
            "$cod1 , $cod2 , $cod3",
          );
    } else {
      myResults = [];
    }
    //
    myPurchases = excludeCourseSubscribers ? [] : await client.from("purchases").select("uuid").eq("item_id", locator<TeacherData>().email).eq("item_type", "teacher");
    //
    List<String> userIds = myResults.map((e) => e["user_id"] as String).toSet().toList();
    userIds.addAll(myPurchases.map((e) => e["uuid"] as String).toSet().toList());
    userIds = userIds.toSet().toList();
    const chunkSize = 200;
    final chunks = chunk(userIds, chunkSize);
    List<Map<String, dynamic>> allUsers = [];
    for (var chunk in chunks) {
      try {
        //
        final PostgrestList myUsers;
        //
        chunk.removeWhere((element) => element.isEmpty);
        //
        myUsers = await client.from("users_data").select().inFilter("uuid", chunk);
        //
        allUsers.addAll(myUsers);
      } on Exception {
        rethrow;
      }
    }

    //
    List<UserData> students = allUsers.map((e) {
      return UserDataModel.fromJson(e);
    }).toList();
    //
    students = removeDuplicateUuids(students);
    //
    // return users;
    return GetMyStudentsResponse(
      banksIds: banksIds,
      testsIds: testsIds,
      students: students,
    );
  }

  @override
  Future<List<Result>> getStudentResults({
    required String id,
    required bool update,
  }) async {
    final client = Supabase.instance.client;
    //
    final teacherData = locator<TeacherData>();
    //s
    final List<Map> banksRes;
    final List<Map> testsRes;
    final List<Map> emailsRes;
    //
    // get my tests ids
    final List<Map> myTestsIds;
    //
    final List<Map> myBanksIds;
    //
    myTestsIds = await client.from("tests").select("id").eq("teacher_email", teacherData.email).order("id");
    //
    myBanksIds = await client.from("banks").select("id").eq("teacher_email", teacherData.email).order("id");
    //
    testsRes = await client
        .from("results")
        .select()
        .eq("user_id", id)
        .inFilter(
          "test_id",
          myTestsIds.map((e) => e["id"]).toList(),
        )
        .order("id");
    //
    banksRes = await client
        .from("results")
        .select()
        .eq("user_id", id)
        .inFilter(
          "bank_id",
          myBanksIds.map((e) => e["id"]).toList(),
        )
        .order("id");

    //
    emailsRes = await client.from("results").select().eq("user_id", id).eq("teacher_email", locator<TeacherData>().email).order("id");
    //
    if ((testsRes + banksRes + emailsRes).isNotEmpty) {
      //
      return (testsRes + banksRes + emailsRes).map((e) => ResultModel.fromJson(e)).toList();
    }
    //
    return [];
  }

  @override
  Future<List<Result>> getRepositoryResults({
    required Test? test,
    required OuterTest? outerTest,
    required Bank? bank,
    required bool update,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    final List<Map> res;
    //
    if (test != null) {
      res = await client.from("results").select().eq("test_id", test.id).order("id");
    } else if (outerTest != null) {
      res = await client.from("results").select().eq("outer_test_id", outerTest.id).order("id");
    } else {
      res = await client.from("results").select().eq("bank_id", bank!.id).order("id");
    }
    //
    if (res.isNotEmpty) {
      var list = res.map((e) => ResultModel.fromJson(e)).toList();
      return list;
    }
    //
    return [];
  }

  @override
  Future<List<UserData>> searchInMyStudents({
    required String text,
    required bool update,
  }) async {
    //
    // final client = client;
    final client = Supabase.instance.client;
    //
    final teacherData = locator<TeacherData>();
    //
    // get my tests ids
    final List<Map> myTestsIds;
    //
    myTestsIds = await client.from("tests").select().eq("teacher_email", teacherData.email);
    //
    // get result using tests ids
    final List<Map> myResults;
    //
    myResults = await client.from("results").select().inFilter("test_id", myTestsIds.map((e) => e["id"]).toList());
    //
    // getting users ids
    final List<Map> myUsers;
    //
    myUsers = await client.from("users_data").select().or("email.contains.$text").inFilter("uuid", myResults.map((e) => e["user_id"]).toList()).order("name");
    //
    return myUsers.map((e) => UserDataModel.fromJson(e)).toList();
  }

  @override
  Future<double> getRepositoryAverage({
    required String? testId,
    required String? bankId,
    required String? outerTestId,
    required bool update,
  }) async {
    //
    late double average;
    // get bank/test
    final Either getRepositoryRes;
    final PostgrestList resultsRes;
    // get
    final client = Supabase.instance.client;
    //

    if (testId != null) {
      // get repository
      getRepositoryRes = await locator<GetTestByIdUC>().call(
        testId: int.parse(testId),
        update: update,
      );
      // get results
      resultsRes = await client.from("results").select().eq("test_id", testId);
    } else if (outerTestId != null) {
      // get repository
      getRepositoryRes = await locator<GetOuterTestByIdUseCase>().call(
        id: int.parse(outerTestId),
      );
      // get results
      resultsRes = await client.from("results").select().eq("outer_test_id", outerTestId);
    } else {
      // get repository
      getRepositoryRes = await locator<GetBankByIdUC>().call(
        bankId: int.parse(bankId!),
        update: update,
      );
      // get results
      resultsRes = await client.from("results").select().eq("bank_id", bankId);
    }
    //
    if (getRepositoryRes.isRight() && resultsRes.isNotEmpty) {
      //
      List<Result> results = [];
      //
      results = resultsRes.map((e) => ResultModel.fromJson(e)).toList();
      //
      getRepositoryRes.fold(
        (l) {},
        (r) {
          final details = locator<GetRepositoryDetailsUC>().call(
            test: testId != null ? r : null,
            bank: bankId != null ? r : null,
            outerTest: outerTestId != null ? r : null,
            results: results,
            update: update,
          );
          average = details.averageMark;
        },
      );
    }
    //
    return average * 100;
  }

  @override
  Future<Unit> deleteRepositoryResults({
    required List<int>? results,
    int? testId,
    int? outerTestId,
    int? bankId,
  }) async {
    //
    if (results == null) return unit;
    //
    if (results.isEmpty) return unit;
    //
    final client = Supabase.instance.client;
    //
    if (outerTestId != null) {
      await client.from("results").delete().inFilter("id", results).eq("outer_test_id", outerTestId);
    }
    //
    if (bankId != null) {
      await client.from("results").delete().inFilter("id", results).eq("bank_id", bankId);
    }
    //
    if (testId != null) {
      await client.from("results").delete().inFilter("id", results).eq("test_id", testId);
    }
    if (testId == null && bankId == null) {
      await client.from("results").delete().inFilter("id", results).eq("teacher_email", locator<TeacherData>().email);
    }
    //
    return unit;
  }

  @override
  Future<List<UserData>> getMyStudentsByIds({required List<String> ids}) async {
    //
    final List myUsers;
    //
    final client = Supabase.instance.client;
    //
    myUsers = await client.from("users_data").select().inFilter("uuid", ids).order("name");
    //

    return myUsers.map((e) => UserDataModel.fromJson(e)).toList();
  }

  @override
  Future<Unit> addResults({required List<Result> results}) async {
    //
    final client = Supabase.instance.client;
    //
    List<UserData> usersData = [];
    //
    if (results.first.userId.isEmpty) {
      await locator<GetUsersDataByIdsUC>().call(ids: results.map((e) => e.userNumber).toList(), isUuid: false).then((response) {
        response.fold(
          (l) {},
          (r) {
            usersData = r;
          },
        );
      });
    }
    //
    List list = results.map((e) {
      UserData? userData = usersData.where((data) {
        String modifiedUserNumber = e.userNumber.toString().substring(1);
        return data.id == modifiedUserNumber;
      }).firstOrNull;
      return ResultModel.fromClass(e.copyWith(userId: userData?.uuid)).toJson();
    }).toList();
    //
    await client.from("results").insert(list);
    //
    return unit;
  }

  @override
  Future<GetMyStudentsStatisticsResponse> getMyStudentsStatistics({
    required List<UserData> students,
  }) async {
    final client = Supabase.instance.client;
    //
    final response = await getMyStudents();
    //
    final List<Map<String, dynamic>> testsJson = await client
        //
        .from("tests")
        .select("id , information->>title")
        .inFilter("id", response.testsIds);
    //
    final List<Map<String, dynamic>> recordsJson = await client
        //
        .from("attendance_records")
        .select("student_id,attendance_set_id")
        .inFilter("student_id", students.map((e) => e.id).toList());

    //
    final List<Map<String, dynamic>> resultsJson = await client
        //
        .from("results")
        .select("user_id,mark,date,test_id,answers")
        .inFilter("test_id", response.testsIds);

    final List<Result> results = resultsJson.map((e) => ResultModel.fromStatisticsQuery(e)).toList();
    final List<AttendanceRecord> records = recordsJson.map((e) => AttendanceRecordModel.fromStatisticsQuery(e)).toList();
    // final List<Test> tests = testsJson.map((e) => TestModel.fromJson(e)).toList();

    // Store user marks
    Map<String, List<StudentTestMarkDetails>> userMarksHolder = {};
    for (var r in results) {
      userMarksHolder.putIfAbsent(r.userId, () => []).add(
            StudentTestMarkDetails(
              testId: r.testId ?? -1,
              mark: r.mark,
              date: r.date,
            ),
          );
    }

    // Generate student row details
    final List<StudentRowDetails> rows = students.map((s) {
      List<StudentTestMarkDetails> marks = userMarksHolder[s.uuid] ?? [];
      //
      // Step 1: Group by ID
      Map<int, List<StudentTestMarkDetails>> grouped = {};
      for (var mark in marks) {
        int id = mark.testId;
        grouped.putIfAbsent(id, () => []).add(mark);
      }
      //
      // Step 2: Sort each group by date
      grouped.forEach((id, list) {
        list.sort((a, b) => a.date.compareTo(b.date)); // Oldest first
      });
      //
      // Step 3: Extract the oldest item from each group
      List<StudentTestMarkDetails> newMarks = grouped.values.map((list) => list.first).toList();

      //
      return StudentRowDetails(
        name: s.name,
        userId: s.id,
        marks: newMarks,
        records: records.where((e) => e.studentId == s.id).toList(),
      );
    }).toList();

    return GetMyStudentsStatisticsResponse(
      rows: rows,
      tests: testsJson.map((e) {
        return (
          e['id'] as int,
          e['title'] as String,
        );
      }).toList(),
    );
  }
}

List<List<T>> chunk<T>(List<T> list, int chunkSize) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += chunkSize) {
    chunks.add(list.sublist(
      i,
      i + chunkSize > list.length ? list.length : i + chunkSize,
    ));
  }
  return chunks;
}

List<UserData> removeDuplicateUuids(List<UserData> userList) {
  final Set<String> uniqueUuids = {};
  final List<UserData> filteredList = [];

  for (var user in userList) {
    if (uniqueUuids.add(user.uuid)) {
      filteredList.add(user);
    }
  }

  return filteredList;
}
