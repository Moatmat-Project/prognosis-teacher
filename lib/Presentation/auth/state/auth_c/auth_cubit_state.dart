part of 'auth_cubit_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthOnBoarding extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthStartAuth extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSignIn extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSignUP extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthDone extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthError extends AuthState {
  final String? error;

  const AuthError({ this.error});
  @override
  List<Object> get props => [];
}

final class AuthResetPassword extends AuthState {
  @override
  List<Object> get props => [];
}
final class AuthUpdate extends AuthState {
  final UpdateInfo updateInfo;

  const AuthUpdate({required this.updateInfo});
  @override
  List<Object?> get props => [updateInfo];
}