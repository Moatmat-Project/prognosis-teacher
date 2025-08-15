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
import 'package:moatmat_teacher/Features/tests/data/models/test_m.dart';
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
  Future<GetMyStudentsStatisticsResponse> getMyStudentsResults({
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
    try {
      final response = await Supabase.instance.client.rpc(
        "testing",
        params: {
          "teacher_email_param": locator<TeacherData>().email,
          "exclude_course_subscribers": excludeCourseSubscribers,
          "exclude_banks": excludeBanks,
          "exclude_tests": excludeTests,
        },
      );

      // Parse the response
      List<UserData> students = (response["users"] as List<dynamic>?)?.map((e) => UserDataModel.fromJson(e)).toList() ?? [];

      return GetMyStudentsResponse(
        banksIds: response["banks_ids"].cast<int>(),
        testsIds: response["tests_ids"].cast<int>(),
        students: students,
      );
    } catch (e) {
      if (e is PostgrestException && e.code == '57014') {
        throw Exception('The operation timed out. Please try again.');
      }
      rethrow;
    }
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
  Future<GetMyStudentsStatisticsResponse> getMyStudentsResults({
    required List<UserData> students,
  }) async {
    final client = Supabase.instance.client;

    // Call the new function
    final statsResponse = await client.rpc(
      'get_teacher_student_statistics',
      params: {
        'teacher_email_param': client.auth.currentUser?.email,
        'student_ids_param': students.map((e) => e.id).toList(),
      },
    );

    // Parse the raw data - handle the single row result
    final testsJson = (statsResponse[0]['tests_data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final recordsJson = (statsResponse[0]['attendance_data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final resultsJson = (statsResponse[0]['results_data'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // Continue with your existing processing logic...
    final List<AttendanceRecord> records = recordsJson.map((e) => AttendanceRecordModel.fromStatisticsQuery(e)).toList();
    final List<Result> results = resultsJson.map((e) => ResultModel.fromJson(e)).toList();

    // Rest of your existing code remains the same...
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
          (e['information'] as Map<String, dynamic>)['title'] as String,
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
