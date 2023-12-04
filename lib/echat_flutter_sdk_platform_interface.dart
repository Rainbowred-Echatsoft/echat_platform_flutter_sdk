import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'echat_flutter_sdk_method_channel.dart';


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
}
