import 'package:echat_platform_flutter_sdk/echat_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _echatPlatformFlutterSdkPlugin = EChatFlutterSdk();

  @override
  void initState() {
    super.initState();
    setDefaultSDKConfig();
    initSDK();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EChat FlutterSDK example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  openChat();
                },
                child: const Text("打开聊天窗口 - 全功能"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  openBox();
                },
                child: const Text("打开消息盒子 - echatTag: flutter"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setUserInfo();
                },
                child: const Text("设置会员接口"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  clearUserInfo();
                },
                child: const Text("清理会员"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 设置默认sdk参数
  void setDefaultSDKConfig() {
    ///正式环境 多商户
    ///appId SDKCV5XSSVPFGSK5N6U
    ///appSecret CTBMXIKRDRYTFQVRZQ3ZJAPIMN2QVK62D53MBGCXBJE
    ///serverAppId 8546F8346D6BB48840B763000231F1A1
    ///serverEncodingkey 7k263sdcmyvEY3OZjAsZ4RONB4zaZgOZEgEKntEbYNn
    ///serverToken 2fr6R3jL
    ///platformId 523055
    //设置配置

    ///测试环境 多商户
    ///appId SDKATFXTZXR2EMI7UKU
    ///appSecret XQDHSZJCKHD8TNOC2FASM7E8PDKHFNNGOOQ4KCY4Q6U
    ///serverAppId 506CF39AE722D7634432E5C438ED8CBA
    ///serverEncodingkey MzFjM2ZjYjBmOGJiNGQ5Y2IxMDQ0ZTAzZmExYjJhMWE
    ///serverToken AQ3Nsg9U
    ///platformId 521704
    EChatFlutterSdk.setConfig(
      appId: 'SDKCV5XSSVPFGSK5N6U',
      appSecret: "CTBMXIKRDRYTFQVRZQ3ZJAPIMN2QVK62D53MBGCXBJE",
      serverAppId: "8546F8346D6BB48840B763000231F1A1",
      serverEncodingKey: "7k263sdcmyvEY3OZjAsZ4RONB4zaZgOZEgEKntEbYNn",
      serverToken: "2fr6R3jL",
      companyId: 523055,
      isAgreePrivacy: true,
      // serverUrl: "https://chat.rainbowred.com",
    );
  }

  /// SDK初始化
  void initSDK() {
    EChatFlutterSdk.init();
  }

  ///打开对话
  void openChat() async {
    var visEvt = EchatVisEvtModel(
      eventId: "cook1002",
      title: "西西里＃韩国秋冬百搭纯色V领衬衫 ",
      content:
          "<div style='color:#666;line-height:20px'>原价：<span style='text-decoration:line-through'>¥185.50</span></div><div style='color:#666;line-height:20px'>促销：<span style='color:red'>¥104.70</span></div><div style='color:#666;line-height:20px'>运费：<span style='color:#ccc'>卖家承担运费</span></div>",
      imageUrl:
          "https://demo.echatsoft.com/web/html/demoMall/url/visitorUrl/myproduct/images/2.jpg",
      urlForVisitor:
          "http('https://demo.echatsoft.com/web/html/demoMall/url/staffUrl/myproduct/?eventId=cook1002','inner')",
      urlForStaff: "apiUrl(123,'hash')",
      memo: "评价（4000）",
    );
    await EChatFlutterSdk.openChat(
        companyId: 523055,
        visEvt: visEvt,
        echatTag: "flutter",
        myData: "flutter-myData",
        fm: EchatFMModel.createTextMessage(content: "这是Fm功能"));
  }

  //打开消息盒子
  void openBox() async {
    await EChatFlutterSdk.openBox(echatTag: "flutter");
  }

  ///设置会员
  void setUserInfo() async {
    var userInfo = EchatUserInfo(uid: "123456789", name: "张三");
    await EChatFlutterSdk.setUserInfo(userInfo);
  }

  ///清理会员
  void clearUserInfo() async {
    await EChatFlutterSdk.clearUserInfo();
  }
}
