#import "EchatPlatformFlutterSdkPlugin.h"

@implementation EchatPlatformFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"echat_platform_flutter_sdk"
            binaryMessenger:[registrar messenger]];
  EchatPlatformFlutterSdkPlugin* instance = [[EchatPlatformFlutterSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"setConfig" isEqualToString:call.method]){
      NSLog(@"echatSDK config = \n%@", call.arguments);
  }else if ([@"init" isEqualToString:call.method]){
      
  }else{
      result(FlutterMethodNotImplemented);
  }
}

@end
