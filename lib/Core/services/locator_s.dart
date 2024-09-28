import 'package:moatmat_teacher/Core/injection/app_inj.dart';

class LocatorService {
  //
  static Future<void> registerSingleton<T extends Object>(T instance) async {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
    locator.registerSingleton<T>(instance);
  }

  static bool isRegistered<T extends Object>() {
    return locator.isRegistered<T>();
  }

  static Future<void> unregister<T extends Object>() async {
    if (locator.isRegistered<T>()) {
      locator.unregister<T>();
    }
  }

  static T get<T extends Object>() {
    return locator.get<T>();
  }
}
