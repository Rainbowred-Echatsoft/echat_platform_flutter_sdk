import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'echat_flutter_sdk_platform_interface.dart';
import 'echat_flutter_sdk.dart';

/// An implementation of [EChatFlutterSdkPlatform] that uses method channels.
class MethodChannelEchatFlutterSdk extends EChatFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('echat_platform_flutter_sdk');

  /// msg信道, 用于未读消息传递
  final EventChannel msgChannel = const EventChannel('echat_msg_channel');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
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
      String? serverUrl}) async {
    Map<String, dynamic> config = {
      if (serverUrl != null) 'serverUrl': serverUrl,
      "appId": appId,
      "appSecret": appSecret,
      "serverAppId": serverAppId,
      "serverEncodingKey": serverEncodingKey,
      "serverToken": serverToken,
      "companyId": companyId,
      "isAgreePrivacy": isAgreePrivacy
    };
    config.removeWhere((key, value) => value == null);
    final result = await methodChannel.invokeMethod<bool>('setConfig', config);
    return result ?? false;
  }

  @override
  Future<bool> init() async {
    final result = await methodChannel.invokeMethod<bool>('init');
    return result ?? false;
  }

  @override
  Future<void> openChat({
    required int companyId,
    EchatVisEvtModel? visEvt,
    String? echatTag,
    String? myData,
    String? routeEntranceId,
    String? acdStaffId,
    String? acdType,
    EchatFMModel? fm,
  }) async {
    Map<String, dynamic> map = {
      "companyId": companyId,
      "visEvt": visEvt?.toMap(),
      "echatTag": echatTag,
      "myData": myData,
      "routeEntranceId": routeEntranceId,
      "acdStaffId": acdStaffId,
      "acdType": acdType,
      "fm": fm?.toMap()
    };
    map.removeWhere((key, value) => value == null);
    await methodChannel.invokeMethod('openChat', map);
  }

  @override
  Future<void> openBox({String? echatTag}) async {
    Map<String, dynamic> map = {
      "echatTag": echatTag,
    };
    map.removeWhere((key, value) => value == null);
    await methodChannel.invokeMethod('openBox', map);
  }

  @override
  Future<void> setUserInfo(EchatUserInfo userInfo) {
    return methodChannel.invokeMethod<void>('setMember', userInfo.toMap());
  }

  @override
  Future<void> clearUserInfo() {
    return methodChannel.invokeMethod<void>('clearMember');
  }
}
