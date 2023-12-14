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

  @override
  Future<bool> init() {
    // TODO: implement setMember
    throw UnimplementedError();
  }

  @override
  Future<void> openChat(
      {required int companyId,
      EchatVisEvtModel? visEvt,
      String? echatTag,
      String? myData,
      String? routeEntranceId,
      String? acdStaffId,
      String? acdType,
      EchatFMModel? fm}) {
    // TODO: implement setMember
    throw UnimplementedError();
  }

  @override
  Future<bool> setConfig(
      {required String appId,
      required String appSecret,
      required String serverAppId,
      required String serverEncodingKey,
      required String serverToken,
      required int companyId,
      required bool isAgreePrivacy,
      String? serverUrl}) {
    // TODO: implement setMember
    throw UnimplementedError();
  }

  @override
  Future<void> clearUserInfo() {
    // TODO: implement clearMember
    throw UnimplementedError();
  }

  @override
  Future<void> setUserInfo(EchatUserInfo userInfo) {
    // TODO: implement setMember
    throw UnimplementedError();
  }

  @override
  Future<void> openBox({String? echatTag}) {
    // TODO: implement openBox
    throw UnimplementedError();
  }

  @override
  Future<void> getUnreadMsg(void Function(dynamic msg) msgCallBack) {
    // TODO: implement getUnreadMsg
    throw UnimplementedError();
  }

  @override
  Future<void> getUnreadMsgCount(
      void Function(dynamic count) msgCountCallBack) {
    // TODO: implement getUnreadMsgCount
    throw UnimplementedError();
  }
}

void main() {
  final EChatFlutterSdkPlatform initialPlatform =
      EChatFlutterSdkPlatform.instance;

  test('$MethodChannelEchatFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEchatFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    EChatFlutterSdk echatPlatformFlutterSdkPlugin = EChatFlutterSdk();
    MockEchatPlatformFlutterSdkPlatform fakePlatform =
        MockEchatPlatformFlutterSdkPlatform();
    EChatFlutterSdkPlatform.instance = fakePlatform;

    expect(await echatPlatformFlutterSdkPlugin.getPlatformVersion(), '42');
  });
}
