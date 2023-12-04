import 'package:echat_platform_flutter_sdk/echat_flutter_sdk.dart';
import 'package:echat_platform_flutter_sdk/echat_flutter_sdk_method_channel.dart';
import 'package:echat_platform_flutter_sdk/echat_flutter_sdk_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEchatPlatformFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements EChatFlutterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EChatFlutterSdkPlatform initialPlatform = EChatFlutterSdkPlatform.instance;

  test('$MethodChannelEchatFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEchatFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    EchatFlutterSdk echatPlatformFlutterSdkPlugin = EchatFlutterSdk();
    MockEchatPlatformFlutterSdkPlatform fakePlatform = MockEchatPlatformFlutterSdkPlatform();
    EChatFlutterSdkPlatform.instance = fakePlatform;

    expect(await echatPlatformFlutterSdkPlugin.getPlatformVersion(), '42');
  });
}
