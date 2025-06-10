import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entites/update_info.dart';
import '../models/update_info_m.dart';

abstract class UpdateRemoteDS {
  Future<UpdateInfo> checkUpdateState();
}

class UpdateRemoteDSImpl implements UpdateRemoteDS {
  @override
  Future<UpdateInfo> checkUpdateState() async {
    //
    late UpdateInfo info;
    //
    final client = Supabase.instance.client;
    //
    final versions = await client.from("versions").select().eq(
          "app",
          "teacher",
        );
    //
    info = UpdateInfoModel.fromJson(versions.first);
    //
    info = info.copyWith(appVersion: await getVersion());
    //
    Map data = client.auth.currentUser?.userMetadata ?? {};
    //
    data["version"] = info.appVersion;
    //
    await client.auth.updateUser(
      UserAttributes(
        data: data,
      ),
    );
    //
    await client.auth.refreshSession();
    //
    return info;
  }

  Future<int> getVersion() async {
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //
    String version = packageInfo.version;
    //
    String versionNumberString = version.replaceAll('.', '');
    //
    int versionNumber = int.parse(versionNumberString);
    //
    return versionNumber;
  }
}
