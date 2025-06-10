import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_teacher/Core/services/classification_s.dart';
import 'package:moatmat_teacher/Features/students/domain/entities/user_data.dart';

part 'explore_class_students_state.dart';

class ExploreClassStudentsCubit extends Cubit<ExploreClassStudentsState> {
  ExploreClassStudentsCubit() : super(ExploreClassStudentsLoading());
  late String classs;
  init({String? classs}) async {
    //
    this.classs = classs ?? this.classs;
    //
    emit(ExploreClassStudentsLoading());
    //
    final users =
        await ClassificationService().getByClass(classs ?? this.classs);
    //
    emit(ExploreClassStudentsInitial(users: users));
  }
}
