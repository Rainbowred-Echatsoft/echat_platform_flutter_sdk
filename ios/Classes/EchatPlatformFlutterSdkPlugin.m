#import "EchatPlatformFlutterSdkPlugin.h"
#import "EchatPlatformSDK.h"

@interface EchatPlatformFlutterSdkPlugin()<EchatConversationDelegate, FlutterStreamHandler>
@property(nonatomic, copy) NSString * appId;
@property(nonatomic, copy) NSString * appSecret;
@property(nonatomic, copy) NSString * serverAppId;
@property(nonatomic, copy) NSString * serverEncodingKey;
@property(nonatomic, copy) NSString * serverToken;
@property(nonatomic, copy) NSString * companyId;
@property(nonatomic, copy) NSString * serverUrl;
@end

FlutterEventSink     eventMsgSink;
FlutterEventSink     eventCountSink;
@implementation EchatPlatformFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    [EchatSDK performSelector:@selector(setDebug:) withObject:@(YES)];
    
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"echat_platform_flutter_sdk"
                                     binaryMessenger:[registrar messenger]];
    EchatPlatformFlutterSdkPlugin* instance = [[EchatPlatformFlutterSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
//    FlutterEventChannel * unreadMsgChannel = [FlutterEventChannel eventChannelWithName:@"echat_message_channel" binaryMessenger:[registrar messenger]];
//    [unreadMsgChannel setStreamHandler:instance];
    
    FlutterEventChannel * unreadCountChannel = [FlutterEventChannel eventChannelWithName:@"echat_count_channel" binaryMessenger:[registrar messenger]];
    [unreadCountChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"setConfig" isEqualToString:call.method]){
        [self setConfig:call.arguments];
    }else if ([@"init" isEqualToString:call.method]){
        [self initSDK];
    }else if ([@"openChat" isEqualToString:call.method]){
        [self openChat:call.arguments];
    }else if ([@"setUserInfo" isEqualToString:call.method]){
        [self setUserInfo:call.arguments];
    }else if ([@"getUserInfo" isEqualToString:call.method]){
        [self getUserInfo:result];
    }else if ([@"clearUserInfo" isEqualToString:call.method]){
        [self clearMember];
    }else if ([@"openBox" isEqualToString:call.method]){
        [self openBox];
    }else if ([@"closeConnection" isEqualToString:call.method]){
        [self closeConnection];
    }else if ([@"closeAllChat" isEqualToString:call.method]){
        [self closeAllChat:result];
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

- (void)getUserInfo:(FlutterResult)result{
    NSDictionary * dict = [self dictionaryFromUserInfo];
    result(dict);
}

- (void)clearMember{
    [EchatSDK clearUserInfo];
}

- (void)closeConnection{
    [EchatConversationManager disConnect];
}

- (void)closeAllChat:(FlutterResult)result{
    [EchatConversationManager closeAllConversationSuccess:^{
        result(@(YES));
    } fail:^(NSString * _Nonnull errorMsg) {
        result(@(NO));
    }];
}

#pragma mark -evenChannelDelegate
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    if (![arguments isKindOfClass:[NSString class]]){
        return nil;
    }
    
    if ([arguments isEqualToString:@"EchatUnreadMsg"]){
        [EchatConversationManager manager].delegate = self;
        eventMsgSink = events;
    }else if ([arguments isEqualToString:@"EchatUnreadCount"]){
        [EchatConversationManager manager].delegate = self;
        eventCountSink = events;
        if (eventCountSink){
            NSInteger count = [EchatConversationManager manager].getAllUnreadCountSum;
            eventCountSink([NSString stringWithFormat:@"%ld",(long)count]);
        }
    }
    
    
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments{
    
    eventMsgSink = nil;
    eventCountSink = nil;
    return nil;
}


#pragma mark - sdkDelegate
- (void)getReceivedMessage:(Echat_MsgModel *)message{
    if (eventMsgSink){
        eventMsgSink(message.content);
    }
}

- (void)unReadMessagesSumCountChanged:(NSInteger)count{
    if (eventCountSink){
        eventCountSink([NSString stringWithFormat:@"%ld",count]);
    }
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

- (NSDictionary *)dictionaryFromUserInfo{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    EchatUserInfo * userInfo = [EchatSDK getUserInfo];
    if (userInfo == nil) return nil;
    [dict setValue:userInfo.uid forKey:@"uid"];
    [dict setValue:@(userInfo.vip) forKey:@"vip"];
    [dict setValue:userInfo.grade forKey:@"grade"];
    [dict setValue:userInfo.category forKey:@"category"];
    [dict setValue:userInfo.name forKey:@"name"];
    [dict setValue:userInfo.nickName forKey:@"nickName"];
    [dict setValue:@(userInfo.gender) forKey:@"gender"];
    [dict setValue:@(userInfo.age) forKey:@"age"];
    [dict setValue:userInfo.birthday forKey:@"birthday"];
    [dict setValue:userInfo.maritalStatus forKey:@"maritalStatus"];
    [dict setValue:userInfo.phone forKey:@"phone"];
    [dict setValue:userInfo.qq forKey:@"qq"];
    [dict setValue:userInfo.wechat forKey:@"wechat"];
    [dict setValue:userInfo.nation forKey:@"nation"];
    [dict setValue:userInfo.email forKey:@"email"];
    [dict setValue:userInfo.province forKey:@"province"];
    [dict setValue:userInfo.city forKey:@"city"];
    [dict setValue:userInfo.address forKey:@"address"];
    [dict setValue:userInfo.photo forKey:@"photo"];
    [dict setValue:userInfo.memo forKey:@"memo"];
    [dict setValue:userInfo.c1 forKey:@"c1"];
    [dict setValue:userInfo.c2 forKey:@"c2"];
    [dict setValue:userInfo.c3 forKey:@"c3"];
    [dict setValue:userInfo.c4 forKey:@"c4"];
    [dict setValue:userInfo.c5 forKey:@"c5"];
    [dict setValue:userInfo.c6 forKey:@"c6"];
    [dict setValue:userInfo.c7 forKey:@"c7"];
    [dict setValue:userInfo.c8 forKey:@"c8"];
    [dict setValue:userInfo.c9 forKey:@"c9"];
    [dict setValue:userInfo.c10 forKey:@"c10"];
    [dict setValue:userInfo.c11 forKey:@"c11"];
    [dict setValue:userInfo.c12 forKey:@"c12"];
    [dict setValue:userInfo.c13 forKey:@"c13"];
    [dict setValue:userInfo.c14 forKey:@"c14"];
    [dict setValue:userInfo.c15 forKey:@"c15"];
    [dict setValue:userInfo.c16 forKey:@"c16"];
    [dict setValue:userInfo.c17 forKey:@"c17"];
    [dict setValue:userInfo.c18 forKey:@"c18"];
    [dict setValue:userInfo.c19 forKey:@"c19"];
    [dict setValue:userInfo.c20 forKey:@"c20"];

    NSDictionary * result = [NSDictionary dictionaryWithDictionary:dict];
    return result;
}
@end
