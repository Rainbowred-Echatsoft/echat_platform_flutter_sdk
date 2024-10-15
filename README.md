# EChat Platform Flutter SDK.

一洽专业在线客服系统，可通过网站、微信、APP、小程序、微博、Facebook、Line、WhatsApp、邮件、贴子等任意渠道接入。系统智能支持：多样式选择、多路由接入、多业务整合、多角色监控、多维度分析，多平台统一管理

## SDK 简介

一洽 echat_platform_flutter_sdk 插件，封装了Android & iOS原生SDK常用API，使用该插件，无须调用原生API即可使用一洽服务。 

## 集成文档

完整文档请参考：[Flutter 插件集成文档](https://wiki.echatsoft.com/sdk/flutter-platform/#/)

## 1. 集成Flutter插件

在 Flutter 项目的 `pubspec.yaml` 文件中 dependencies 里面添加 `echat_platform_flutter_sdk` 依赖。

> 当前版本 {{flutterVersion}}，请将代码块中`[version]`替换成{{flutterVersion}}

```yaml
dependencies:
  # 添加一洽SDK插件
  echat_platform_flutter_sdk: ^[version]
```

执行 flutter pub get 命令安装插件。

```bash
flutter pub get
```

!> 注意：Android需要手动添加一洽maven服务器地址，否则会出现打包Android失败的情况

在 Flutter 项目的 `android/build.gradle`中

```groovy
allprojects {
    repositories {
        // 保留官方仓库地址
        google()
        mavenCentral()
        // 添加一洽maven服务器地址
        maven { url "https://nexus.rainbowred.com/repository/sdk/" }
    }
}
```

## 2. 配置权限

### 2.1 Android 权限配置

在 Flutter 项目，打开`android/app/src/main/AndroidManifest.xml`，将下面权限添加到`<manifest>`与`</manifest>`之间。

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FLASHLIGHT" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.VIBRATE" />

<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>

<!-- Android 13 要求 -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />

<!-- Android 14 要求 -->
<uses-permission android:name="android.permission.READ_MEDIA_VISUAL_USER_SELECTED" /> 
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_REMOTE_MESSAGING" />
```

若当前android项目的targetSdkVersion较低，可能打包出现AndroidManifest.xml merge合并错误，请根据情况删除对应的权限。

若使用的`flutter sdk`在`3.12.0 - 3.19.6`时，则需要适配Android 13要求。

若使用的`flutter sdk`版本大于等于`3.22.0`时，则需要适配Android13 与 Android 14要求。

### 2.2 Android 14 依赖适配

考虑到版本适配性，若使用的`flutter sdk`版本大于等于`3.22.0`(Android targetSDK大于34时)，需要在android中引入一个依赖库。文件目录为`根目录/android/app/build.gradle`，找到`dependencies`，添加`implementation("com.echatsoft.echatsdk.platform:android14:1.0.0.0")`

```
dependencies {
  implementation("com.echatsoft.echatsdk.platform:android14:1.0.0.0")
}
```

### 2.3 Android 混淆配置

在 Flutter 项目，打开`android/app/proguard-rules.pro`，将SDK混淆配置追加到该文件内容之后。

```
# EChat SDK混淆配置
-dontwarn com.echatsoft.**
-keep class com.echatsoft.** { *; }
-keep class org.cometd.** { *; }
-keep class org.eclipse.** { *; }

# EChat SDK 默认使用的图片加载库混淆配置
-keep class com.bumptech.glide.** { *; }
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class * extends com.bumptech.glide.module.AppGlideModule { *; }
```

如果当前的混淆设置能够保证应用在发布(release)模式下正常运行，那么您不需要参照完整的混淆配置方案进行设置。

对于那些尚未设置任何混淆规则的项目，您可以采用以下提供的完整混淆配置指导进行配置。请参考[完整的混淆配置指南](https://wiki.echatsoft.com/sdk/app-platform/#/proguard-example)。


### 2.4 iOS 权限配置

打开iOS项目中的podfile文件.添加如下代码至文件末尾

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
            config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
        end
    target.build_configurations.each do |config|
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
            '$(inherited)',
            'PERMISSION_MICROPHONE=1',
            'PERMISSION_CAMERA=1',
            'PERMISSION_PHOTOS=1',
          ]
        end
  end
end
```


## 3. 配置参数

### 3.1 调试开关

> 如需查看SDK打印日志，请将以下配置项设置为true

非必要无须配置，配置请放在`配置参数`/`初始化`之前

```dart
EChatFlutterSdk.setDebug(debug: true);
```
### 3.2 SDK配置参数

关于配置参数，请联系技术支持获取，请勿随意配置参数。

| 参数              | 类型   | 作用                     | 必须 |
| ----------------- | ------ | ------------------------ | ---- |
| appId             | String | SDK初始化参数            | 是   |
| appSecret         | String | SDK初始化参数            | 是   |
| serverAppId       | String | SDK初始化参数            | 是   |
| serverEncodingKey | String | SDK加密参数              | 是   |
| serverToken       | String | SDK加密参数              | 是   |
| serverToken       | String | SDK加密参数              | 是   |
| companyId         | int    | 公司/平台id              | 是   |
| isAgreePrivacy    | bool   | 客户是否已经同意隐私协议 | 是   |
|serverUrl|String|服务器地址，非必要误填|否|

> 配置参数必须在Flutter启动时，第一时间设置，兼容了隐私合规。

* 首次App启动，此时客户还未同意隐私协议，设置setConfig，isAgreePrivacy = false
* 用户同意隐私协议后，每次App启动，都需要设置setConfig，且isAgreePrivacy = true

```dart
EChatFlutterSdk.setConfig(
    appId: 'SDKCV5XSSVPFGSKXXXX',
    appSecret: "CTBMXIKRDRYTFQVRZQ3ZJAPIMN2QVK62D53MBGXXXX",
    serverAppId: "8546F8346D6BB48840B763000231XXXX",
    serverEncodingKey: "7k263sdcmyvEY3OZjAsZ4RONB4zaZgOZEgEKntEXXXX",
    serverToken: "2fr6XXXX",
    companyId: 5230XX,
    isAgreePrivacy: isAgreePrivacy,
);
```

!> 注意：原生SDK没有专门用于配置参数的接口，是在初始化时进行配置参数。若选择Flutter端配置参数，就不需要再原生端调用任何与初始化有关的API。


### 4. 初始化

```dart
EChatFlutterSdk.init();
```

> 若App有合规需求，可以参考 [隐私合规](TODO)

### 5. 对话窗口

#### 5.1 打开对话窗口

接口参数：

| 参数            | 类型             | 作用                       | 必须 |
| --------------- | ---------------- | -------------------------- | ---- |
| companyId       | int              | 公司id                     | 是   |
| echatTag        | String           | 对话入口标识               | 否   |
| myData          | String           | 会员补充信息               | 否   |
| routeEntranceId | String           | 咨询入口                   | 否   |
| visEvt          | EchatVisEvtModel | 图文消息                   | 否   |
| acdStaffId      | String           | 指派接待客服的ID           | 否   |
| acdType         | String           | 分配优先级，0-优先，1-指派 | 否   |
| fm              | EchatFMModel     | 接入对话带入访客消息       | 否   |

仅打开对话
```dart
EChatFlutterSdk.openChat(companyId: xxx);
```

