import 'package:moatmat_teacher/Features/colleges/data/models/college_m.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../Core/errors/exceptions.dart';

abstract class CollegeRemoteDataSource {
  Future<void> addCollege(CollegeModel college);
  Future<void> updateCollege(CollegeModel college);
  Future<List<CollegeModel>> getAllColleges();
  Future<List<CollegeModel>> getCollegesBySchoolId(int schoolId);
  Future<void> deleteCollege(int id);
}

class CollegeRemoteDataSourceImpl implements CollegeRemoteDataSource {
  final SupabaseClient supabaseClient;
  CollegeRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> addCollege(CollegeModel college) async {
    try {
      final data = college.toJson()
        ..remove('id'); // Remove ID for auto-generation
      await supabaseClient.from('colleges').insert(data);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteCollege(int id) async {
    try {
      await supabaseClient.from('colleges').delete().eq('id', id);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<CollegeModel>> getAllColleges() async {
    try {
      final response = await supabaseClient.from('colleges').select('*');
      return (response as List)
          .map((college) => CollegeModel.fromJson(college))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<CollegeModel>> getCollegesBySchoolId(int schoolId) async {
    try {
      final response = await supabaseClient
          .from('colleges')
          .select('*')
          .eq('school_id', schoolId);
      return (response as List)
          .map((college) => CollegeModel.fromJson(college))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateCollege(CollegeModel college) async {
    try {
      await supabaseClient
          .from('colleges')
          .update(college.toJson()..remove('id'))
          .eq('id', college.id);
    } catch (e) {
      throw ServerException();
    }
  }
}
