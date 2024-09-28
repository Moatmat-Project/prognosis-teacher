import '../../domain/entities/user_data.dart';

class UserDataModel extends UserData {
  UserDataModel({
    required super.uuid,
    required super.id,
    required super.balance,
    required super.name,
    required super.email,
    required super.motherName,
    required super.age,
    required super.classroom,
    required super.schoolName,
    required super.governorate,
    required super.phoneNumber,
    required super.whatsappNumber,
    required super.tests,
  });
  factory UserDataModel.fromJson(Map json) {
    return UserDataModel(
      uuid: json["uuid"],
      id: json["id"].toString(),
      balance: json["balance"],
      name: json["name"],
      email: json["email"],
      motherName: json["mother_name"],
      age: json["age"],
      classroom: json["classroom"],
      schoolName: json["school_name"],
      governorate: json["governorate"],
      phoneNumber: json["phone_number"],
      whatsappNumber: json["whatsapp_number"],
      tests: List.generate((json["tests"] as List).length, (index) {
        return (
          json["tests"][0]["id"] as int,
          json["tests"][0]["name"] as String,
        );
      }),
    );
  }
  factory UserDataModel.fromClass(UserData userData) {
    return UserDataModel(
      uuid: userData.uuid,
      id: userData.id,
      balance: userData.balance,
      name: userData.name,
      email: userData.email,
      motherName: userData.motherName,
      age: userData.age,
      classroom: userData.classroom,
      schoolName: userData.schoolName,
      governorate: userData.governorate,
      phoneNumber: userData.phoneNumber,
      whatsappNumber: userData.whatsappNumber,
      tests: userData.tests,
    );
  }

  toJson() {
    return {
      "uuid": uuid,
      "id": id,
      "balance": balance,
      "name": name.trim(),
      "email": email.trim(),
      "mother_name": motherName.trim(),
      "age": age.trim(),
      "classroom": classroom,
      "school_name": schoolName.trim(),
      "governorate": governorate,
      "phone_number": phoneNumber.trim(),
      "whatsapp_number": whatsappNumber.trim(),
      "tests": tests.map((e) {
        return {"id": e.$1, "name": e.$2};
      }).toList(),
    };
  }
}
