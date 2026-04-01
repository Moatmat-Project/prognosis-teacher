part of 'college_bloc.dart';

sealed class CollegeEvent extends Equatable {
  const CollegeEvent();

  @override
  List<Object> get props => [];
}

class FetchColleges extends CollegeEvent {}

class FetchCollegesBySchoolId extends CollegeEvent {
  final int schoolId;

  const FetchCollegesBySchoolId(this.schoolId);

  @override
  List<Object> get props => [schoolId];
}

class AddCollegeEvent extends CollegeEvent {
  final College college;

  const AddCollegeEvent(this.college);

  @override
  List<Object> get props => [college];
}

class UpdateCollegeEvent extends CollegeEvent {
  final College college;

  const UpdateCollegeEvent(this.college);

  @override
  List<Object> get props => [college];
}

class DeleteCollegeEvent extends CollegeEvent {
  final int id;

  const DeleteCollegeEvent(this.id);

  @override
  List<Object> get props => [id];
}
