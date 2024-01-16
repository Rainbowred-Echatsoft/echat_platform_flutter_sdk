package com.echatsoft.echatsdk.echat_platform_flutter_sdk

import android.app.Activity
import android.os.Bundle
import android.util.Log
import androidx.collection.ArrayMap
import com.echatsoft.echatsdk.core.EChatSDK
import com.echatsoft.echatsdk.core.ICore
import com.echatsoft.echatsdk.core.OnePaces
import com.echatsoft.echatsdk.core.model.ChatParamConfig
import com.echatsoft.echatsdk.core.model.ExtraParamConfig
import com.echatsoft.echatsdk.core.model.UserInfo
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
import java.lang.reflect.Modifier

/** EchatPlatformFlutterSdkPlugin */
class EchatPlatformFlutterSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    companion object {
        const val TAG = "EChat_Flutter"
    }

    private var mActivity: Activity? = null
    private var debug: Boolean = false

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
        if (debug) {
            Log.i(TAG, "onMethodCall current thread -> ${Thread.currentThread()}")
        }
        when (call.method) {
            "setDebug" -> {
                setDebug(call, result)
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

            "openBox" -> {
                openBox(call, result)
            }

            "setUserInfo" -> {
                setUserInfo(call, result)
            }

            "getUserInfo" -> {
                getUserInfo(call, result)
            }

            "clearUserInfo" -> {
                clearUserInfo(call, result)
            }

            "closeConnection" -> closeConnection(result)

            "closeAllChat" -> closeAllChat(result)

            else -> {
                result.notImplemented()
            }
        }
    }


    private fun setDebug(call: MethodCall, result: Result) {
        try {
            val argument = call.argument<Any>("debug")
            Log.i(TAG, "obj type -> ${argument?.javaClass}")
            debug = call.argument<Boolean>("debug") == true
            OnePaces.setDebug(debug)
        } catch (e: Exception) {
            Log.e(TAG, "setDebug", e)
        }
        result.success(null)
    }

    private fun setConfig(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "setConfig application is null")
                result.success(false)
                return
            }
            if (debug) {
                LogUtils.iTag(TAG, "SetConfig -> ${GsonUtils.toJson(call.arguments)}")
            }
            val serverUrl = call.argument<String>("serverUrl")
            val appId = call.argument<String>("appId")
            val appSecret = call.argument<String>("appSecret")
            val serverAppId = call.argument<String>("serverAppId")
            val serverEncodingKey = call.argument<String>("serverEncodingKey")
            val serverToken = call.argument<String>("serverToken")
            val companyId = call.argument<Int>("companyId")
            val isAgreePrivacy = call.argument<Boolean>("isAgreePrivacy")

            if (debug) {
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
            }

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

    private fun setUserInfo(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "setUserInfo application is null")
                result.success(false)
                return
            }

            val params = call.arguments<Map<String, Any>>() ?: emptyMap()
            // params和UserInfo数据一致，从params中取值
            val userInfo = UserInfo().apply {
                uid = params["uid"] as? String
                vip = params["vip"] as? Int ?: 0
                grade = params["grade"] as? String
                category = params["category"] as? String
                name = params["name"] as? String
                nickName = params["nickName"] as? String
                gender = params["gender"] as? Int
                age = params["age"] as? Int
                birthday = params["birthday"] as? String
                maritalStatus = params["maritalStatus"] as? Int
                phone = params["phone"] as? String
                qq = params["qq"] as? String
                wechat = params["wechat"] as? String
                email = params["email"] as? String
                nation = params["nation"] as? String
                province = params["province"] as? String
                city = params["city"] as? String
                address = params["address"] as? String
                photo = params["photo"] as? String
                memo = params["memo"] as? String
                c1 = params["c1"] as? String
                c2 = params["c2"] as? String
                c3 = params["c3"] as? String
                c4 = params["c4"] as? String
                c5 = params["c5"] as? String
                c6 = params["c6"] as? String
                c7 = params["c7"] as? String
                c8 = params["c8"] as? String
                c9 = params["c9"] as? String
                c10 = params["c10"] as? String
                c11 = params["c11"] as? String
                c12 = params["c12"] as? String
                c13 = params["c13"] as? String
                c14 = params["c14"] as? String
                c15 = params["c15"] as? String
                c16 = params["c16"] as? String
                c17 = params["c17"] as? String
                c18 = params["c18"] as? String
                c19 = params["c19"] as? String
                c20 = params["c20"] as? String
            }
            EChatSDK.getInstance().userInfo = userInfo
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "setUserInfo", e)
            result.success(false)
        }
    }

    private fun getUserInfo(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "setUserInfo application is null")
                result.success(null)
                return
            }
            val userInfo = EChatSDK.getInstance().userInfo
            if (userInfo == null) {
                result.success(null)
                return
            }
            // 将userInfo对象的每个值取出来，放到map中
            result.success(objectToMap(userInfo))
        } catch (e: Exception) {
            Log.e(TAG, "setUserInfo", e)
            result.success(null)
        }
    }

    private fun clearUserInfo(call: MethodCall, result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "clearUserInfo application is null")
                result.success(false)
                return
            }

            EChatSDK.getInstance().clearUserInfo()
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "clearUserInfo", e)
            result.success(false)
        }
    }

    private fun closeConnection(result: Result) {
        try {
            if (mActivity == null) {
                Log.e(TAG, "closeConnection application is null")
                result.success(false)
                return
            }

            EChatSDK.getInstance().closeConnection { flag, msg ->
                if (flag) {
                    result.success(true)
                } else {
                    result.error("closeConnection", msg, null)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "closeConnection", e)
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

    private fun objectToMap(any: Any): Map<String, Any> {
        val membersMap = ArrayMap<String, Any>()
        val fields = any::class.java.declaredFields
        for (field in fields) {
            if (field.modifiers and Modifier.PRIVATE != 0 && field.modifiers and Modifier.STATIC == 0) {
                field.isAccessible = true
                val fieldValue = field.get(any)
                if (fieldValue != null) {
                    membersMap[field.name] = fieldValue
                }
            }
        }
        return membersMap
    }
}
