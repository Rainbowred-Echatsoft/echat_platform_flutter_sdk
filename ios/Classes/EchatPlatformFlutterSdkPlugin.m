#import "EchatPlatformFlutterSdkPlugin.h"
#import "EchatPlatformSDK.h"

@interface EchatPlatformFlutterSdkPlugin()
@property(nonatomic, copy) NSString * appId;
@property(nonatomic, copy) NSString * appSecret;
@property(nonatomic, copy) NSString * serverAppId;
@property(nonatomic, copy) NSString * serverEncodingKey;
@property(nonatomic, copy) NSString * serverToken;
@property(nonatomic, copy) NSString * companyId;
@property(nonatomic, copy) NSString * serverUrl;
@end

@implementation EchatPlatformFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"echat_platform_flutter_sdk"
            binaryMessenger:[registrar messenger]];
  EchatPlatformFlutterSdkPlugin* instance = [[EchatPlatformFlutterSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"setConfig" isEqualToString:call.method]){
        NSLog(@"echatSDK config = \n%@", call.arguments);
        [self setConfig:call.arguments];
    }else if ([@"init" isEqualToString:call.method]){
        [self initSDK];
    }else if ([@"openChat" isEqualToString:call.method]){
        [self openChat:call.arguments];
    }else if ([@"setMember" isEqualToString:call.method]){
        [self setUserInfo:call.arguments];
    }else if ([@"clearMember" isEqualToString:call.method]){
        [self clearMember];
    }else if ([@"openBox" isEqualToString:call.method]){
        [self openBox];
    }else{
        result(FlutterMethodNotImplemented);
    }
}


#pragma mark -- private methods

//SDK设置
-(void)setConfig:(id)value{
    if (![value isKindOfClass:[NSDictionary class]]){
        NSLog(@"setConfig value's type error");
        return;
    }
    
    NSMutableDictionary * dictM = [NSMutableDictionary dictionaryWithDictionary:value];
    
    id companyIdValue = [dictM objectForKey:@"companyId"];
    if (![companyIdValue isKindOfClass:[NSString class]]){
        companyIdValue = [NSString stringWithFormat:@"%@",companyIdValue];
    }
    
    //特殊处理
    if ([dictM objectForKey:@"isAgreePrivacy"]){
        [dictM removeObjectForKey:@"isAgreePrivacy"];
    }
    
    
    NSString * appId = [[dictM objectForKey:@"appId"] stringByReplacingOccurrencesOfString:@" " withString:@""];;
    NSString * appSecret = [[dictM objectForKey:@"appSecret"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * serverAppId = [[dictM objectForKey:@"serverAppId"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * serverEncodingKey = [[dictM objectForKey:@"serverEncodingKey"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * serverToken = [[dictM objectForKey:@"serverToken"] stringByReplacingOccurrencesOfString:@" " withString:@""];;
    NSString * companyId = [companyIdValue stringByReplacingOccurrencesOfString:@" " withString:@""];;
    NSString * serverUrl = [[dictM objectForKey:@"serverUrl"]stringByReplacingOccurrencesOfString:@" " withString:@""];;
    
    
    self.appId = appId;
    self.appSecret = appSecret;
    self.serverAppId = serverAppId;
    self.serverEncodingKey = serverEncodingKey;
    self.serverToken = serverToken;
    self.companyId = companyId;
    self.serverUrl = serverUrl;
}

//初始化SDK
- (void)initSDK{
    [EchatSDK startSDKWithAppID:self.appId
                      AppSecret:self.appSecret
                    serverAppId:self.serverAppId
              serverEncodingKey:self.serverEncodingKey
                    serverToken:self.serverToken
                      companyId:self.companyId
                      serverUrl:self.serverUrl];
}

//打开对话
-(void)openChat:(id)value{
    if(![value isKindOfClass:[NSDictionary class]]){
        return;
    }
    
    //特殊处理
    NSMutableDictionary * dictM = [NSMutableDictionary dictionaryWithDictionary:value];
    NSString * companyId = dictM[@"companyId"];
    [dictM removeObjectForKey:@"companyId"];
    dictM[@"shopId"] = companyId;
    
    
    NSLog(@"condition: conditionClass = %@ \n%@",[value class],value);

    Echat_accessConditions * condition = [[Echat_accessConditions alloc] init];
    //这里直接利用native方法转模型,value的key名不能错
    [condition setValuesForKeysWithDictionary:dictM];
    
    EchatChatController * chatVC = [EchatChatController chatWithCondition:condition];
    [self toPush:chatVC];

}

- (void)openBox{
    EchatMessageBoxController * box = [[EchatMessageBoxController alloc] init];
    [self toPush:box];
}

- (void)setUserInfo:(id)value{
    if(![value isKindOfClass:[NSDictionary class]]){
        return;
    }
    
    NSLog(@"setUserInfo: userInfo = %@ \n%@",[value class],value);
    EchatUserInfo * userInfo = [[EchatUserInfo alloc] init];
    [userInfo setValuesForKeysWithDictionary:value];
    
    [EchatSDK setUserInfo:userInfo];
}

- (void)clearMember{
    [EchatSDK clearUserInfo];
}


#pragma mark -others
- (void)toPush:(UIViewController *)controller{
    // 获取当前的 FlutterViewController
    UIViewController *flutterViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    // 推送原生控制器
    if (flutterViewController.navigationController){
        [flutterViewController.navigationController pushViewController:controller animated:YES];
        
    }else{
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:controller];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [flutterViewController presentViewController:navi animated:YES completion:nil];
    }
}
@end
