part of 'college_bloc.dart';

sealed class CollegeState extends Equatable {
  const CollegeState();

  @override
  List<Object> get props => [];
}

class CollegeInitial extends CollegeState {}

class CollegeLoading extends CollegeState {}

class CollegeLoaded extends CollegeState {
  final List<College> colleges;

  const CollegeLoaded({required this.colleges});

  @override
  List<Object> get props => [colleges];
}

class CollegeError extends CollegeState {
  final String message;

  const CollegeError({required this.message});

  @override
  List<Object> get props => [message];
}

class CollegeActionSuccess extends CollegeState {
  final String message;

  const CollegeActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
