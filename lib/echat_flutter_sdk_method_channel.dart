import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'echat_flutter_sdk_platform_interface.dart';
import 'echat_flutter_sdk.dart';

/// An implementation of [EChatFlutterSdkPlatform] that uses method channels.
class MethodChannelEchatFlutterSdk extends EChatFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('echat_platform_flutter_sdk');

  /// count信道, 用于未读消息数传递
  final EventChannel countChannel = const EventChannel('echat_count_channel');

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
  Future<void> setDebug({required bool debug}) async {
    methodChannel.invokeMethod('setDebug', {"debug": debug});
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
    return methodChannel.invokeMethod<void>('setUserInfo', userInfo.toMap());
  }

  @override
  Future<EchatUserInfo?> getUserInfo() async {
    final result = await methodChannel.invokeMethod('getUserInfo');
    return result == null
        ? null
        : EchatUserInfo.toModel(data: Map.from(result));
  }

  @override
  Future<bool> clearUserInfo() async {
    return await methodChannel.invokeMethod('clearUserInfo');
  }

  @override
  Future<void> getUnreadMsgCount(
      void Function(dynamic count) msgCountCallBack) async {
    countChannel
        .receiveBroadcastStream('EchatUnreadCount')
        .listen(msgCountCallBack);
  }

  @override
  Future<bool> closeConnection() async {
    var result = await methodChannel.invokeMethod('closeConnection');
    if (Platform.isIOS) {
      return true;
    }
    return result;
  }

  @override
  Future<bool> closeAllChats() async {
    return await methodChannel.invokeMethod('closeAllChats');
  }
}
