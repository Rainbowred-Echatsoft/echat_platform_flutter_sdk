// ignore_for_file: slash_for_doc_comments

import 'echat_flutter_sdk_platform_interface.dart';

//*******************插件主类**********/
class EChatFlutterSdk {
  /// SDK 调试日志
  /// [debug]: true: 开启debug模式; false: 关闭debug模式
  static Future<void> setDebug({required bool debug}) {
    return EChatFlutterSdkPlatform.instance.setDebug(debug: debug);
  }

  /// sdk设置
  /// [serverUrl]: 服务器地址,不填写即为默认;形如:https://e.echatsoft.com
  /// [appId]: app唯一ID
  /// [appSecret]: app密钥
  /// [serverAppId]: API接入ID
  /// [serverEncodingKey]: 消息加密key
  /// [serverToken]: API接入Token
  /// [companyId]: 公司Id, 如果是多商户接入则写入平台公司Id，如果是单商户接入则写入公司Id
  /// [isAgreePrivacy]: 是否同意隐私协议
  static Future<void> setConfig({
    String? serverUrl,
    required String appId,
    required String appSecret,
    required String serverAppId,
    required String serverEncodingKey,
    required String serverToken,
    required int companyId,
    required bool isAgreePrivacy,
  }) =>
      EChatFlutterSdkPlatform.instance.setConfig(
        serverUrl: serverUrl,
        appId: appId,
        appSecret: appSecret,
        serverAppId: serverAppId,
        serverEncodingKey: serverEncodingKey,
        serverToken: serverToken,
        companyId: companyId,
        isAgreePrivacy: isAgreePrivacy,
      );

  /// sdk初始化: 需要在setConfig之后调用
  static Future<void> init() {
    return EChatFlutterSdkPlatform.instance.init();
  }

  /// 跳转咨询控制器
  static Future<void> openChat({
    required int companyId,
    EchatVisEvtModel? visEvt,
    String? echatTag,
    String? myData,
    String? routeEntranceId,
    String? acdStaffId,
    String? acdType,
    EchatFMModel? fm,
  }) {
    return EChatFlutterSdkPlatform.instance.openChat(
        companyId: companyId,
        visEvt: visEvt,
        echatTag: echatTag,
        myData: myData,
        routeEntranceId: routeEntranceId,
        acdStaffId: acdStaffId,
        acdType: acdType,
        fm: fm);
  }

  /// 打开消息盒子
  static Future<void> openBox({
    String? echatTag,
  }) {
    return EChatFlutterSdkPlatform.instance.openBox(
      echatTag: echatTag,
    );
  }

  /// 设置会员
  static Future<void> setUserInfo(EchatUserInfo userInfo) {
    return EChatFlutterSdkPlatform.instance.setUserInfo(userInfo);
  }

  /// 会员信息获取
  static Future<EchatUserInfo?> getUserInfo() {
    return EChatFlutterSdkPlatform.instance.getUserInfo();
  }

  /// 会员信息清除
  static Future<bool> clearUserInfo() {
    return EChatFlutterSdkPlatform.instance.clearUserInfo();
  }

  /// 获取消息总数
  static Future<void> getUnreadMsgCount(
      void Function(dynamic count) msgCountCallBack) {
    return EChatFlutterSdkPlatform.instance.getUnreadMsgCount(msgCountCallBack);
  }

  /// 关闭链接
  static Future<bool> closeConnection() {
    return EChatFlutterSdkPlatform.instance.closeConnection();
  }

  /// 关闭所有对话
  static Future<bool> closeAllChat() async {
    return await EChatFlutterSdkPlatform.instance.closeAllChat();
  }
}

//*******************一些关于Ehat使用相关类**********/

/// ***Echat图文对象类***
class EchatVisEvtModel {
  String? eventId;
  String? title;
  String? content;
  String? imageUrl;
  String? urlForVisitor;
  String? urlForStaff;
  String? memo;
  int dedup = 1;
  int visibility = 1;
  int customizeMsgType = 1;

  EchatVisEvtModel({
    this.eventId,
    this.title,
    this.content,
    this.imageUrl,
    this.urlForVisitor,
    this.urlForStaff,
    this.memo,
    this.dedup = 1,
    this.visibility = 1,
    this.customizeMsgType = 1,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'imageUrl': imageUrl,
      'content': content,
      'title': title,
      'eventId': eventId,
      'urlForVisitor': urlForVisitor,
      'urlForStaff': urlForStaff,
      'memo': memo,
      'dedup': dedup,
      'visibility': visibility,
      'customizeMsgType': customizeMsgType
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

/// ***访客自动默认发出第一条消息类***
class EchatFMModel {
  String msgType;
  String? content;
  String? picUrl;
  String? thumbUrl;
  String? fileUrl;
  String? fileNam;
  String? fileSize;

  /// 构造方法
  EchatFMModel._(
      {required this.msgType,
      this.content,
      this.picUrl,
      this.thumbUrl,
      this.fileUrl,
      this.fileNam,
      this.fileSize});

  // 工厂方法
  factory EchatFMModel({
    required String msgType,
    String? content,
    String? picUrl,
    String? thumbUrl,
    String? fileUrl,
    String? fileNam,
    String? fileSize,
  }) {
    return EchatFMModel._(
      msgType: msgType,
      content: content,
      picUrl: picUrl,
      thumbUrl: thumbUrl,
      fileUrl: fileUrl,
      fileNam: fileNam,
      fileSize: fileSize,
    );
  }

  /// 文本消息
  static EchatFMModel createTextMessage({required String content}) {
    return EchatFMModel._(
      msgType: "text",
      content: content,
    );
  }

  /// 图片消息
  static EchatFMModel createImageMessage(
      {required String picUrl, required String thumbUrl}) {
    return EchatFMModel._(
      msgType: "image",
      picUrl: picUrl,
      thumbUrl: thumbUrl,
    );
  }

  /// 视频消息
  static EchatFMModel createVideoMessage(
      {required String fileUrl,
      required String fileNam,
      required String fileSize,
      required String thumbUrl}) {
    return EchatFMModel._(
      msgType: "video",
      fileUrl: fileUrl,
      fileNam: fileNam,
      fileSize: fileSize,
      thumbUrl: thumbUrl,
    );
  }

  /// 文件消息
  static EchatFMModel createFileMessage(
      {required String fileUrl,
      required String fileNam,
      required String fileSize}) {
    return EchatFMModel._(
        msgType: "file",
        fileUrl: fileUrl,
        fileNam: fileNam,
        fileSize: fileSize);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "msgType": msgType,
      "content": content,
      "picUrl": picUrl,
      "thumbUrl": thumbUrl,
      "fileUrl": fileUrl,
      "fileNam": fileNam,
      "fileSize": fileSize,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

/// ***会员信息类***
class EchatUserInfo {
  String uid;
  int vip = 1;
  String? grade;
  String? category;
  String? name;
  String? nickName;
  int? gender;
  int? age;
  String? birthday;
  int? maritalStatus;
  String? phone;
  String? qq;
  String? wechat;
  String? email;
  String? nation;
  String? province;
  String? city;
  String? address;
  String? photo;
  String? memo;

  /**
   * 会员自定义字段
   * 最长不超过255位
   */
  String? c1;
  String? c2;
  String? c3;
  String? c4;
  String? c5;
  String? c6;
  String? c7;
  String? c8;
  String? c9;
  String? c10;
  String? c11;
  String? c12;
  String? c13;
  String? c14;
  String? c15;
  String? c16;
  String? c17;
  String? c18;
  String? c19;
  String? c20;

  EchatUserInfo({
    required this.uid,
    this.vip = 1,
    this.grade,
    this.category,
    this.name,
    this.nickName,
    this.gender,
    this.age,
    this.birthday,
    this.maritalStatus,
    this.phone,
    this.qq,
    this.wechat,
    this.email,
    this.nation,
    this.province,
    this.city,
    this.address,
    this.photo,
    this.memo,
    //自定义参数
    this.c1,
    this.c2,
    this.c3,
    this.c4,
    this.c5,
    this.c6,
    this.c7,
    this.c8,
    this.c9,
    this.c10,
    this.c11,
    this.c12,
    this.c13,
    this.c14,
    this.c15,
    this.c16,
    this.c17,
    this.c18,
    this.c19,
    this.c20,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'uid': uid,
      'vip': vip,
      'grade': grade,
      'category': category,
      'name': name,
      'nickName': nickName,
      'gender': gender,
      'age': age,
      'birthday': birthday,
      'maritalStatus': maritalStatus,
      'phone': phone,
      'qq': qq,
      'wechat': wechat,
      'email': email,
      'nation': nation,
      'province': province,
      'city': city,
      'address': address,
      'photo': photo,
      'memo': memo,
      'c1': c1,
      'c2': c2,
      'c3': c3,
      'c4': c4,
      'c5': c5,
      'c6': c6,
      'c7': c7,
      'c8': c8,
      'c9': c9,
      'c10': c10,
      'c11': c11,
      'c12': c12,
      'c13': c13,
      'c14': c14,
      'c15': c15,
      'c16': c16,
      'c17': c17,
      'c18': c18,
      'c19': c19,
      'c20': c20,
    };

    map.removeWhere((key, value) => value == null);
    return map;
  }

  static EchatUserInfo? toModel({required Map<String, Object>? data}) {
    if (data == null) {
      return null;
    }
    var userInfo = EchatUserInfo(uid: "");
    var uid = data["uid"] as String?;
    if (uid != null) {
      userInfo.uid = uid;
    }
    userInfo.vip = data["vip"] as int ?? 1;
    userInfo.grade = data["grade"] as String?;
    userInfo.category = data["category"] as String?;
    userInfo.name = data["name"] as String?;
    userInfo.nickName = data["nickName"] as String?;
    userInfo.gender = data["gender"] as int?;
    userInfo.age = data["age"] as int?;
    userInfo.birthday = data["birthday"] as String?;
    userInfo.maritalStatus = data["maritalStatus"] as int?;
    userInfo.phone = data["phone"] as String?;
    userInfo.qq = data["qq"] as String?;
    userInfo.wechat = data["wechat"] as String?;
    userInfo.email = data["email"] as String?;
    userInfo.nation = data["nation"] as String?;
    userInfo.province = data["province"] as String?;
    userInfo.city = data["city"] as String?;
    userInfo.address = data["address"] as String?;
    userInfo.photo = data["photo"] as String?;
    userInfo.memo = data["memo"] as String?;

    userInfo.c1 = data["c1"] as String?;
    userInfo.c2 = data["c2"] as String?;
    userInfo.c3 = data["c3"] as String?;
    userInfo.c4 = data["c4"] as String?;
    userInfo.c5 = data["c5"] as String?;
    userInfo.c6 = data["c6"] as String?;
    userInfo.c8 = data["c8"] as String?;
    userInfo.c9 = data["c9"] as String?;
    userInfo.c10 = data["c10"] as String?;
    userInfo.c11 = data["c11"] as String?;
    userInfo.c12 = data["c12"] as String?;
    userInfo.c13 = data["c13"] as String?;
    userInfo.c14 = data["c14"] as String?;
    userInfo.c15 = data["c15"] as String?;
    userInfo.c16 = data["c16"] as String?;
    userInfo.c17 = data["c17"] as String?;
    userInfo.c18 = data["c18"] as String?;
    userInfo.c19 = data["c19"] as String?;
    userInfo.c20 = data["c20"] as String?;

    return userInfo;
  }
}
