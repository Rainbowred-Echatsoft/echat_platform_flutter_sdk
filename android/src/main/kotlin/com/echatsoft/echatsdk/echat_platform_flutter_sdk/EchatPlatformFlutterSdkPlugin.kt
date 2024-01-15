package com.echatsoft.echatsdk.echat_platform_flutter_sdk

import android.app.Activity
import android.os.Bundle
import android.util.Log
import com.echatsoft.echatsdk.core.EChatSDK
import com.echatsoft.echatsdk.core.OnePaces
import com.echatsoft.echatsdk.core.model.ChatParamConfig
import com.echatsoft.echatsdk.core.model.ExtraParamConfig
import com.echatsoft.echatsdk.core.model.VisEvt
import com.echatsoft.echatsdk.core.utils.GsonUtils
import com.echatsoft.echatsdk.core.utils.LogUtils

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** EchatPlatformFlutterSdkPlugin */
class EchatPlatformFlutterSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    companion object {
        const val TAG = "Flutter"
    }

    private var mActivity: Activity? = null

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "echat_platform_flutter_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.i(TAG, "onMethodCall current thread -> ${Thread.currentThread()}")
        when (call.method) {
            "setConfig" -> {
                setConfig(call, result)
            }

            "initialize", "init" -> {
                initSDK(call, result)
            }

            "openChat", "openChatController" -> {
                openChat(call, result)
            }

            "openBox" -> {
                openBox(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun setConfig(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "setConfig application is null")
                result.success(false)
                return
            }
            LogUtils.iTag("Flutter", "SetConfig -> ${GsonUtils.toJson(call.arguments)}")

            val serverUrl = call.argument<String>("serverUrl")
            val appId = call.argument<String>("appId")
            val appSecret = call.argument<String>("appSecret")
            val serverAppId = call.argument<String>("serverAppId")
            val serverEncodingKey = call.argument<String>("serverEncodingKey")
            val serverToken = call.argument<String>("serverToken")
            val companyId = call.argument<Int>("companyId")
            val isAgreePrivacy = call.argument<Boolean>("isAgreePrivacy")
            LogUtils.iTag(
                "Flutter",
                "serverUrl -> $serverUrl \n" +
                        "appId -> $appId \n" +
                        "appSecret -> $appSecret \n" +
                        "serverAppId -> $serverAppId \n" +
                        "serverEncodingKey -> $serverEncodingKey \n" +
                        "serverToken -> $serverToken \n" +
                        "companyId -> $companyId"
            )

            OnePaces.setConfig(
                mActivity?.application,
                serverUrl,
                appId,
                appSecret,
                serverToken,
                serverAppId,
                serverEncodingKey,
                companyId?.toLong() ?: -1,
                isAgreePrivacy ?: false
            )
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "setConfig", e)
            result.success(false)
        }
    }

    private fun initSDK(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "initSDK application is null")
                result.success(false)
                return
            }
            OnePaces.init(mActivity?.application)
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "initSDK", e)
            result.success(false)
        }
    }

    private fun openChat(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "openChat application is null")
                result.success(false)
                return
            }

            val params = call.arguments<Map<String, Any>>() ?: emptyMap()

            val companyId = params["companyId"] as? Int
            val echatTag = params["echatTag"] as? String
            val myData = params["myData"] as? String
            val routeEntranceId = params["routeEntranceId"] as? String
            val acdType = params["acdType"] as? String
            val acdStaffId = params["acdStaffId"] as? String
            val visEvtMap = params["visEvt"] as? Map<*, *>
            val fmMap = params["fm"] as? Map<String, Any>


            LogUtils.iTag("Flutter", "openChat -> ${GsonUtils.toJson(call.arguments)}")
            LogUtils.iTag("Flutter", "visEvt -> ${GsonUtils.toJson(visEvtMap)}")
            LogUtils.iTag("Flutter", "visEvt type -> ${visEvtMap?.javaClass}")
            LogUtils.iTag("Flutter", "fm -> ${GsonUtils.toJson(fmMap)}")
            LogUtils.iTag("Flutter", "type -> ${call.arguments.javaClass}")

            val paramConfig = ChatParamConfig()
            val extraParamConfig = ExtraParamConfig()

            paramConfig.echatTag = echatTag
            paramConfig.myData = myData

            //判断routeEntranceId是不是数字
            if (!routeEntranceId.isNullOrEmpty() && routeEntranceId.matches(Regex("[0-9]+"))) {
                paramConfig.routeEntranceId = routeEntranceId.toInt()
            }

            paramConfig.routeEntranceId
            extraParamConfig.acdType = acdType
            extraParamConfig.acdStaffId = acdStaffId

            if (visEvtMap != null) {
                val visEvt = VisEvt()
                visEvt.eventId = visEvtMap["eventId"] as? String
                visEvt.title = visEvtMap["title"] as? String
                visEvt.content = visEvtMap["content"] as? String
                visEvt.imageUrl = visEvtMap["imageUrl"] as? String
                visEvt.urlForStaff = visEvtMap["urlForStaff"] as? String
                visEvt.urlForVisitor = visEvtMap["urlForVisitor"] as? String
                visEvt.memo = visEvtMap["memo"] as? String
                visEvt.visibility = visEvtMap["visibility"] as? Int ?: 1
                visEvt.customizeMsgType = visEvtMap["customizeMsgType"] as? Int ?: 1
                paramConfig.visEvt = visEvt
            }

            if (fmMap != null) {
                //fmMap 类型 Map 转成 HashMap
                val newHashMap = HashMap<String, String>()
                fmMap.forEach {
                    try {
                        newHashMap[it.key] = it.value as String
                    } catch (e: Exception) {
                    }
                }
                extraParamConfig.fm = newHashMap
            }

            if (companyId != null) {
                EChatSDK.getInstance()
                    .openChat(mActivity!!, companyId.toLong(), paramConfig, extraParamConfig)
            } else {
                EChatSDK.getInstance()
                    .openChat(mActivity!!, paramConfig, extraParamConfig)
            }


            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "openChat", e)
            result.success(false)
        }
    }

    private fun openBox(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "openBox application is null")
                result.success(false)
                return
            }
            val echatTag = call.argument<String>("echatTag")
            EChatSDK.getInstance().openBox(mActivity!!, Bundle().apply {
                putString("echatTag", echatTag)
            })
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "openBox", e)
            result.success(false)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // Nothing to do
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        mActivity == null
    }
}
