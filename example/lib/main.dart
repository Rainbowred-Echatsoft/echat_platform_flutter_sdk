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
            ElevatedButton(onPressed: () {}, child: const Text("点击打开聊天控制器")),
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
        companyId: "521704");
  }

  /// SDK初始化
  void initSDK() {
    EchatFlutterSdk.initialize();
  }
}
