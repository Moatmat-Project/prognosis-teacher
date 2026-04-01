import 'package:moatmat_teacher/Core/injection/app_inj.dart';
import 'package:moatmat_teacher/Features/colleges/data/datasources/college_remote_data_source.dart';
import 'package:moatmat_teacher/Features/colleges/data/repository/college_repository_impl.dart';
import 'package:moatmat_teacher/Features/colleges/domain/repository/college_repository.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/add_college_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/delete_college_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/edit_college_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/get_all_colleges_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/get_colleges_by_school_id_uc.dart';
import 'package:moatmat_teacher/Presentation/colleges/state/college_bloc/college_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void injectColleges() {
  _injectDataSources();
  _injectRepositories();
  _injectUseCases();
  _injectBlocs();
}

void _injectDataSources() {
  locator.registerLazySingleton<CollegeRemoteDataSource>(
    () => CollegeRemoteDataSourceImpl(
      supabaseClient: locator<SupabaseClient>(),
    ),
  );
}

void _injectRepositories() {
  locator.registerLazySingleton<CollegeRepository>(
    () => CollegeRepositoryImpl(
      remoteDataSource: locator<CollegeRemoteDataSource>(),
    ),
  );
}

void _injectUseCases() {
  locator.registerLazySingleton(
    () => AddCollegeUC(
      locator<CollegeRepository>(),
    ),
  );

  locator.registerLazySingleton(
    () => EditCollegeUC(
      locator<CollegeRepository>(),
    ),
  );

  locator.registerLazySingleton(
    () => DeleteCollegeUC(
      locator<CollegeRepository>(),
    ),
  );

  locator.registerLazySingleton(
    () => GetAllCollegesUC(
      locator<CollegeRepository>(),
    ),
  );

  locator.registerLazySingleton(
    () => GetCollegesBySchoolIdUC(
      locator<CollegeRepository>(),
    ),
  );
}

void _injectBlocs() {
  locator.registerFactory(
    () => CollegeBloc(
      getAllCollegesUC: locator<GetAllCollegesUC>(),
      getCollegesBySchoolIdUC: locator<GetCollegesBySchoolIdUC>(),
      addCollegeUC: locator<AddCollegeUC>(),
      editCollegeUC: locator<EditCollegeUC>(),
      deleteCollegeUC: locator<DeleteCollegeUC>(),
    ),
  );
}
