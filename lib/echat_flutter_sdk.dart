// ignore_for_file: slash_for_doc_comments

import 'echat_flutter_sdk_platform_interface.dart';

/// TODO: 后面确定接口调整后补充注释
//*******************插件主类**********/
class EChatFlutterSdk {
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

  /// 会员信息清除
  static Future<void> clearUserInfo() {
    return EChatFlutterSdkPlatform.instance.clearUserInfo();
  }

  // 暂时保留
  Future<String?> getPlatformVersion() {
    return EChatFlutterSdkPlatform.instance.getPlatformVersion();
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
  String? nickname;
  int? gender;
  int? age;
  String? birthday;
  String? maritalStatus;
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
    this.nickname,
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
      'nickname': nickname,
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
}
