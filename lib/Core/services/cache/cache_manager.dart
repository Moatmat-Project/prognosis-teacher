import 'package:flutter/foundation.dart';
import 'package:moatmat_teacher/Core/services/cache/cache_constant.dart';
import 'package:path_provider/path_provider.dart';

import 'cache_client.dart';

/// callable class
class CacheManager {
  late CacheClient _cacheClient;

  /// initiate cache clients
  Future<void> init() async {
    //
    _cacheClient = HiveClient();
    //
    await _cacheClient.init(await getApplicationDocumentsDirectory());
    //
  }


  /// return cache client instance
  CacheClient call() {
    return _cacheClient;
  }

  /// check if cache is valid and exists
  Future<bool> isValid(String createdKey, String dataKey) async {
    //
    if (kDebugMode) {
      return false;
    }
    //
    bool createdDateExisted = _cacheClient.exist(createdKey);
    bool dataExisted = _cacheClient.exist(dataKey);
    //
    if (!createdDateExisted || !dataExisted) {
      return false;
    }
    //
    DateTime now = DateTime.now();
    DateTime then = DateTime.parse(await _cacheClient.read(createdKey));
    //
    if (now.difference(then).inSeconds > CacheConstant.cacheValidSeconds) {
      debugPrint("not valid");
      return false;
    }
    return dataExisted && createdDateExisted;
  }
}
