part of 'exceptions.dart';

abstract class Failure extends Equatable {
  final String text;

  const Failure(this.text);
}

class AnonFailure extends Failure {
  const AnonFailure({String text = "حدث خطأ غير معروف"}) : super(text);
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  const OfflineFailure({String text = "لا يوجد اتصال بالإنترنت."}) : super(text);
  @override
  List<Object?> get props => [];
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure({String text = "خطأ في كلمة المرور."}) : super(text);
  @override
  List<Object?> get props => [];
}

class UserAlreadyExcitedFailure extends Failure {
  const UserAlreadyExcitedFailure({String text = "الحساب موجود بالفعل."}) : super(text);
  @override
  List<Object?> get props => [];
}

class CodesUsedFailure extends Failure {
  const CodesUsedFailure({String text = "تم استخدام الكود مسبقا"}) : super(text);
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure({String text = "حدث خطأ أثناء الاتصال بالخادم."}) : super(text);
  @override
  List<Object?> get props => [];
}

class InvalidDataFailure extends Failure {
  const InvalidDataFailure({String text = "خطأ في البيانات المدخلة.!"}) : super(text);
  @override
  List<Object?> get props => [];
}

class NotEnoughtBalaneFailure extends Failure {
  const NotEnoughtBalaneFailure() : super("لا يوجد رصيد كافي لاتمام عملية الشراء.!");
  @override
  List<Object?> get props => [];
}
