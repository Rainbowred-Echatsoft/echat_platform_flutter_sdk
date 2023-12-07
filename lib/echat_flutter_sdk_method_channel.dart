import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'echat_flutter_sdk_platform_interface.dart';
import 'echat_flutter_sdk.dart';

/// An implementation of [EChatFlutterSdkPlatform] that uses method channels.
class MethodChannelEchatFlutterSdk extends EChatFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('echat_platform_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> setConfig(
      {required String appId,
      required String appSecret,
      required String serverAppId,
      required String serverEncodingKey,
      required String serverToken,
      required String companyId,
      String? serverUrl}) async {
    Map<String, dynamic> config = {
      "appId": appId,
      "appSecret": appSecret,
      "serverAppId": serverAppId,
      "serverEncodingKey": serverEncodingKey,
      "serverToken": serverToken,
      "companyId": companyId,
      //iOS 字典中不能为空,如果直接用""字符串代替不严谨,转换成字典后底层将空变成了"<null>"
      "serverUrl": serverUrl
    };
    await methodChannel.invokeMethod<void>('setConfig', config);
  }

  @override
  Future<void> initialize() async {
    await methodChannel.invokeMethod<void>('initialize');
  }

  @override
  Future<void> openChatController({
    required String companyId,
    EchatVisEvtModel? evtModel,
    String? echatTag,
    String? myData,
    String? routeEntranceId,
    String? acdStaffId,
    String? acdType,
    EchatFMModel? fmModel,
  }) async {
    await methodChannel.invokeListMethod('openChatController', {
      "companyId": companyId,
      "evtModel": evtModel?.toMap(),
      "echatTag": echatTag,
      "myData": myData,
      "routeEntranceId": routeEntranceId,
      "acdStaffId": acdStaffId,
      "acdType": acdType,
      "fmModel": fmModel?.toMap(),
    });
  }
}
