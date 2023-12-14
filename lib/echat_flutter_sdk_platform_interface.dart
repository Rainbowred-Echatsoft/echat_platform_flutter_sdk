import 'dart:convert';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'echat_flutter_sdk_method_channel.dart';
import 'echat_flutter_sdk.dart';

abstract class EChatFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a EchatPlatformFlutterSdkPlatform.
  EChatFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static EChatFlutterSdkPlatform _instance = MethodChannelEchatFlutterSdk();

  /// The default instance of [EChatFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelEchatFlutterSdk].
  static EChatFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EChatFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(EChatFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> setConfig({
    String? serverUrl,
    required String appId,
    required String appSecret,
    required String serverAppId,
    required String serverEncodingKey,
    required String serverToken,
    required int companyId,
    required bool isAgreePrivacy,
  }) {
    throw UnimplementedError('sdkInit() has not been implemented.');
  }

  Future<bool> init() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> openChat({
    required int companyId,
    String? echatTag,
    String? myData,
    String? routeEntranceId,
    String? acdStaffId,
    String? acdType,
    EchatVisEvtModel? visEvt,
    EchatFMModel? fm,
  }) {
    throw UnimplementedError('openChatController() has not been implemented.');
  }

  Future<void> openBox({
    String? echatTag,
  }) {
    throw UnimplementedError('openBox() has not been implemented.');
  }

  Future<void> setUserInfo(EchatUserInfo userInfo) {
    throw UnimplementedError('setMember() has not been implemented.');
  }

  Future<void> clearUserInfo() {
    throw UnimplementedError('clearMember() has not been implemented.');
  }

  Future<void> getUnreadMsg(void Function(dynamic msg) msgCallBack) {
    throw UnimplementedError('getUnreadMsg() has not been implemented.');
  }

  Future<void> getUnreadMsgCount(
      void Function(dynamic count) msgCountCallBack) {
    throw UnimplementedError('getUnreadMsgCount() has not been implemented.');
  }
}
