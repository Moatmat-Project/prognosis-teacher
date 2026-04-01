import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/usecase/usecase.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/add_college_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/delete_college_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/edit_college_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/get_all_colleges_uc.dart';
import 'package:moatmat_teacher/Features/colleges/domain/usecases/get_colleges_by_school_id_uc.dart';

part 'college_event.dart';
part 'college_state.dart';

class CollegeBloc extends Bloc<CollegeEvent, CollegeState> {
  final GetAllCollegesUC getAllCollegesUC;
  final GetCollegesBySchoolIdUC getCollegesBySchoolIdUC;
  final AddCollegeUC addCollegeUC;
  final EditCollegeUC editCollegeUC;
  final DeleteCollegeUC deleteCollegeUC;

  CollegeBloc({
    required this.getAllCollegesUC,
    required this.getCollegesBySchoolIdUC,
    required this.addCollegeUC,
    required this.editCollegeUC,
    required this.deleteCollegeUC,
  }) : super(CollegeInitial()) {
    on<FetchColleges>(_onFetchColleges);
    on<FetchCollegesBySchoolId>(_onFetchCollegesBySchoolId);
    on<AddCollegeEvent>(_onAddCollege);
    on<UpdateCollegeEvent>(_onUpdateCollege);
    on<DeleteCollegeEvent>(_onDeleteCollege);
  }

  Future<void> _onFetchColleges(
    FetchColleges event,
    Emitter<CollegeState> emit,
  ) async {
    emit(CollegeLoading());
    final result = await getAllCollegesUC(NoParams());
    result.fold(
      (failure) => emit(CollegeError(message: "حدث خطا ما")),
      (colleges) => emit(CollegeLoaded(colleges: colleges)),
    );
  }

  Future<void> _onFetchCollegesBySchoolId(
    FetchCollegesBySchoolId event,
    Emitter<CollegeState> emit,
  ) async {
    emit(CollegeLoading());
    final result = await getCollegesBySchoolIdUC(event.schoolId);
    result.fold(
      (failure) => emit(CollegeError(message: "حدث خطا ما")),
      (colleges) => emit(CollegeLoaded(colleges: colleges)),
    );
  }

  Future<void> _onAddCollege(
    AddCollegeEvent event,
    Emitter<CollegeState> emit,
  ) async {
    emit(CollegeLoading());
    final result = await addCollegeUC(event.college);
    result.fold(
      (failure) => emit(CollegeError(message: "حدث خطا ما")),
      (_) => emit(
          const CollegeActionSuccess(message: 'College added successfully')),
    );
  }

  Future<void> _onUpdateCollege(
    UpdateCollegeEvent event,
    Emitter<CollegeState> emit,
  ) async {
    emit(CollegeLoading());
    final result = await editCollegeUC(event.college);
    result.fold(
      (failure) => emit(CollegeError(message: "حدث خطا ما")),
      (_) => emit(
          const CollegeActionSuccess(message: 'College updated successfully')),
    );
  }

  Future<void> _onDeleteCollege(
    DeleteCollegeEvent event,
    Emitter<CollegeState> emit,
  ) async {
    emit(CollegeLoading());
    final result = await deleteCollegeUC(event.id);
    result.fold(
      (failure) => emit(CollegeError(message: "حدث خطا ما")),
      (_) => emit(
          const CollegeActionSuccess(message: 'College deleted successfully')),
    );
  }
}
