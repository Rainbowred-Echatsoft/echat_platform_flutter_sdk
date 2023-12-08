package com.echatsoft.echatsdk.echat_platform_flutter_sdk

import android.app.Activity
import android.util.Log
import androidx.annotation.NonNull
import com.echatsoft.echatsdk.core.EChatSDK
import com.echatsoft.echatsdk.core.OnePaces
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
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "setConfig" -> {
                setConfig(call, result)
            }

            "initialize", "init" -> {
                initSDK(call, result)
            }

            "openChat", "openChatController" -> {
                openChat(call, result)
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

            EChatSDK.getInstance().openChat(mActivity!!, null, null)

            val visEvt = call.argument<Map<String, Any>>("visEvt");
            LogUtils.iTag("Flutter", "openChat -> ${GsonUtils.toJson(call.arguments)}")
            LogUtils.iTag("Flutter", "visEvt -> ${GsonUtils.toJson(visEvt)}")
            LogUtils.iTag("Flutter", "visEvt -> ${visEvt?.javaClass}")

            LogUtils.iTag("Flutter", "type -> ${call.arguments.javaClass}")
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "openChat", e)
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
