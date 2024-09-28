import 'package:dartz/dartz.dart';
import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/buckets/domain/usecases/upload_file_uc.dart';
import 'package:moatmat_teacher/Features/requests/data/models/teacher_request_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/request.dart';

abstract class RequestsDS {
  //
  Stream<String> sendRequest(TeacherRequest request);
  //
  Future<List<TeacherRequest>> getRequests();
}

class RequestsDSImpl implements RequestsDS {
  @override
  Future<List<TeacherRequest>> getRequests() async {
    //
    final client = Supabase.instance.client;
    //
    final res = await client.from("teachers_requests").select();
    //
    final List<TeacherRequest> requests = res.map<TeacherRequest>((e) {
      return TeacherRequestModel.fromJson(e);
    }).toList();
    //
    return requests;
  }

  @override
  Stream<String> sendRequest(TeacherRequest request) async* {
    //
    final client = Supabase.instance.client;
    //
    var model = TeacherRequestModel.fromClass(request).toJson();
    //
    final res = await client.from("teachers_requests").insert(model).select();
    //
    late TeacherRequest newRequest;
    //
    await for (var d in uploadRequestFiles(
      TeacherRequestModel.fromJson(res.first),
    )) {
      if (d is TeacherRequest) {
        newRequest = d;
      } else if (d is String) {
        yield d;
      }
    }
    //
    model = TeacherRequestModel.fromClass(newRequest).toJson();
    //
    await client
        .from("teachers_requests")
        .update(model)
        .eq("id", newRequest.id);
    //
    yield "unit";
  }

  Stream<dynamic> uploadRequestFiles(TeacherRequest request) async* {
    //
    var req = request;
    //
    List<String> files = request.files;
    //
    String? material;
    //p

    //
    material = request.bank?.information.material;
    //
    material = material ?? request.test?.information.material;
    //
    for (int i = 0; i < request.files.length; i++) {
      //
      yield "جاري رفع الملفات ($i/${files.length})";
      //
      var res = await locator<UploadFileUC>().call(
        id: request.id.toString(),
        path: request.files[i],
        bucket: "requests",
        material: material!,
      );
      //
      res.fold((l) {
        throw Exception();
      }, (r) {
        files[i] = r;
      });
    }
    //
    req = request.copyWith(files: files);
    //
    yield req;
  }
}
