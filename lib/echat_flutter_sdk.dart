import 'dart:ffi';

import 'echat_flutter_sdk_platform_interface.dart';

class EchatFlutterSdk {
  /// sdk设置
  /// [appId]: app唯一ID
  /// [appSecret]: app密钥
  /// [serverAppId]: API接入ID
  /// [serverEncodingKey]: 消息加密key
  /// [serverToken]: API接入Token
  /// [companyId]: 公司Id, 如果是多商户接入则写入平台公司Id，如果是单商户接入则写入公司Id
  /// [serverUrl]: 服务器地址,不填写即为默认;形如:https://xxx.xxxx.com
  static Future<void> setConfig(
      {required String appId,
      required String appSecret,
      required String serverAppId,
      required String serverEncodingKey,
      required String serverToken,
      required String companyId,
      String? serverUrl}) {
    return EChatFlutterSdkPlatform.instance.setConfig(
        appId: appId,
        appSecret: appSecret,
        serverAppId: serverAppId,
        serverEncodingKey: serverEncodingKey,
        serverToken: serverToken,
        companyId: companyId);
  }

  /// sdk初始化: 需要在setConfig之后调用
  static Future<void> initialize() {
    return EChatFlutterSdkPlatform.instance.initialize();
  }

  /// 跳转咨询控制器
  static Future<void> openChatController({
    required String companyId,
    EchatVisEvtModel? evtModel,
    String? echatTag,
    String? myData,
    String? routeEntranceId,
    String? acdStaffId,
    String? acdType,
    EchatFMModel? fmModel,
  }) {
    return EChatFlutterSdkPlatform.instance.openChatController(
        companyId: companyId,
        evtModel: evtModel,
        echatTag: echatTag,
        myData: myData,
        routeEntranceId: routeEntranceId,
        acdStaffId: acdStaffId,
        acdType: acdType,
        fmModel: fmModel);
  }
}

/// Echat图文对象
class EchatVisEvtModel {
  String imageUrl;
  String? content;
  String? title;
  String? eventId;
  String? urlForVisitor;
  String? urlForStaff;
  String? memo;
  int visibility;
  int customizeMsgType;

  EchatVisEvtModel(
      {required this.imageUrl,
      this.content,
      this.title,
      this.eventId,
      this.urlForVisitor,
      this.urlForStaff,
      this.memo,
      this.visibility = 1,
      this.customizeMsgType = 2});

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'content': content ?? "",
      'title': title ?? "",
      'eventId': eventId ?? "",
      'urlForVisitor': urlForVisitor ?? "",
      'urlForStaff': urlForStaff ?? "",
      'memo': memo ?? "",
      'visibility': visibility,
      'customizeMsgType': customizeMsgType
    };
  }
}

///访客自动默认发出第一条消息
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
    return {
      "msgType": msgType,
      "content": content,
      "picUrl": picUrl,
      "thumbUrl": thumbUrl,
      "fileUrl": fileUrl,
      "fileNam": fileNam,
      "fileSize": fileSize,
    };
  }
}
