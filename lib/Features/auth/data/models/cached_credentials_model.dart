import '../../domain/entites/cached_credentials.dart';

class CachedCredentialsModel extends CachedCredentials {
  CachedCredentialsModel({
    required super.email,
    required super.password,
  });

  factory CachedCredentialsModel.fromJson(Map<dynamic, dynamic> json) {
    return CachedCredentialsModel(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
