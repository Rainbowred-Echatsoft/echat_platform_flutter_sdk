import 'package:echat_platform_flutter_sdk/echat_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _isAgreePrivacy;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();

    // 一洽SDK初始化
    _initEChatSDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EChat FlutterSDK example app'),
      ),
      body: Center(
        child: FutureBuilder<bool>(
            future: _isAgreePrivacy,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return _sdkFuncMenus();
              } else {
                return const Text("未同意隐私协议");
              }
            }),
      ),
    );
  }

  Widget _sdkFuncMenus() {
    return Column(
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
        // 动态消息展示
        const SizedBox(height: 8),
        Text("未读消息条数: $_unreadCount"),
      ],
    );
  }

  /// SDK初始化
  void _initEChatSDK() async {
    // 获得隐私协议是否同意数据
    _isAgreePrivacy = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool("isAgreePrivacy") ?? false;
    });

    // 是否同意隐私协议 不影响设置参数
    // 不会影响合规性
    // 设置默认sdk参数
    final isAgreePrivacy = await _isAgreePrivacy;
    EChatFlutterSdk.setConfig(
      appId: 'SDKCV5XSSVPFGSK5N6U',
      appSecret: "CTBMXIKRDRYTFQVRZQ3ZJAPIMN2QVK62D53MBGCXBJE",
      serverAppId: "8546F8346D6BB48840B763000231F1A1",
      serverEncodingKey: "7k263sdcmyvEY3OZjAsZ4RONB4zaZgOZEgEKntEbYNn",
      serverToken: "2fr6R3jL",
      companyId: 523055,
      isAgreePrivacy: isAgreePrivacy,
    );

    if (isAgreePrivacy) {
      // 已经同意隐私协议
      EChatFlutterSdk.init();
    } else {
      // 未同意隐私协议
      // 弹出一个dialog窗口
      // 提示用户同意隐私协议
      // 用户点击同意后 调用EChatFlutterSdk.init();
      _showPrivacyPolicyDialog();
    }
    test();
  }

  /// 显示隐私协议弹窗
  /// 用户点击同意后 调用EChatFlutterSdk.init();
  /// 用户点击不同意后 关闭弹窗
  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("隐私协议"),
          content: const Text(
              "请您务必审慎阅读、充分理解“隐私协议”各条款，包括但不限于：为了向您提供即时通讯、内容分享等服务，我们需要收集您的设备信息、操作日志等个人信息。您可以在“设置”中查看、变更、删除个人信息并管理您的授权。您可阅读《隐私协议》了解详细信息。如您同意，请点击“同意”开始接受我们的服务。"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("不同意"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // 同意隐私协议
                final SharedPreferences prefs = await _prefs;
                setState(() {
                  _isAgreePrivacy = prefs
                      .setBool("isAgreePrivacy", true)
                      .then((bool success) {
                    return success;
                  });
                });
                EChatFlutterSdk.init();
              },
              child: const Text("同意"),
            ),
          ],
        );
      },
    );
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

  /// 测试未读和未读消息数
  void test() {
    EChatFlutterSdk.getUnreadMsgCount((count) {
      String countString = count;
      print("未读消息数目: ${countString}");
      int sumCount = int.parse(countString);
      setState(() {
        _unreadCount = sumCount;
      });
    });
  }
}
