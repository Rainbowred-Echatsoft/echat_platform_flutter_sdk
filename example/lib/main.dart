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
  String _platformVersion = 'Unknown';
  final _echatPlatformFlutterSdkPlugin = EchatFlutterSdk();

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
          ],
        )),
      ),
    );
  }

  /// 设置默认sdk参数
  void setDefaultSDKConfig() {
    //设置配置
    EchatFlutterSdk.setConfig(
      appId: 'SDKATFXTZXR2EMI7UKU',
      appSecret: "XQDHSZJCKHD8TNOC2FASM7E8PDKHFNNGOOQ4KCY4Q6U",
      serverAppId: "506CF39AE722D7634432E5C438ED8CBA",
      serverEncodingKey: "MzFjM2ZjYjBmOGJiNGQ5Y2IxMDQ0ZTAzZmExYjJhMWE",
      serverToken: "AQ3Nsg9U",
      companyId: "521704",
      //serverUrl: "https://chat.rainbowred.com",
    );
  }

  /// SDK初始化
  void initSDK() {
    EchatFlutterSdk.initialize();
  }

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
    await EchatFlutterSdk.openChatController(
        companyId: 521704, evtModel: visEvt);
  }
}
