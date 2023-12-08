import 'package:echat_platform_flutter_sdk/echat_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                openChat();
              },
              child: const Text("点击打开聊天控制器"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setMember();
              },
              child: const Text("设置会员接口"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                clearMember();
              },
              child: const Text("清理会员"),
            ),
          ],
        )),
      ),
    );
  }

  /// 设置默认sdk参数
  void setDefaultSDKConfig() {
    //设置配置
    EChatFlutterSdk.setConfig(
      appId: 'SDKC3E2QGTQU7BCIYRD',
      appSecret: "NQXPGFBHBQ4CV3KCAECQWVQWK8MKGQAQ5TJKFZNDAY5",
      serverAppId: "8546F8346D6BB48840B763000231F1A1",
      serverEncodingKey: "7k263sdcmyvEY3OZjAsZ4RONB4zaZgOZEgEKntEbYNn",
      serverToken: "2fr6R3jL",
      companyId: "523055",
    );
  }

  /// SDK初始化
  void initSDK() {
    EChatFlutterSdk.init();
  }

  ///打开对话控制器
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
    await EChatFlutterSdk.openChat(companyId: 521704, visEvt: visEvt);
  }

  ///设置会员
  void setMember() {
    var userInfo = EchatUserInfo(uid: "123456789", name: "张三");
    EChatFlutterSdk.setUserInfo(userInfo);
  }

  ///清理会员
  void clearMember() {
    EChatFlutterSdk.clearUserInfo();
  }
}
