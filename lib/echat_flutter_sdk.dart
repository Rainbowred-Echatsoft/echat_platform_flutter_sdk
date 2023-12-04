

import 'echat_flutter_sdk_platform_interface.dart';

class EchatFlutterSdk {
  Future<String?> getPlatformVersion() {
    return EChatFlutterSdkPlatform.instance.getPlatformVersion();
  }
}
