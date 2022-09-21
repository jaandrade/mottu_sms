package br.com.mottu.sms_plugin

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

/** SmsPlugin */
class SmsPlugin: FlutterPlugin, ActivityAware, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private val activity get() = activityReference.get()
  private val context get() = contextReference.get() ?: activity?.applicationContext

  private var activityReference = WeakReference<Activity>(null)
  private var contextReference = WeakReference<Context>(null)

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sms_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {

      result.success("Android ${android.os.Build.VERSION.RELEASE}")

    } else if(call.method == "sendSms") {

      val phone = call.argument<String>("phone")
      val message = call.argument<String>("message")

      Sms.sendSms(context, phone, message)

    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityReference = WeakReference(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityReference.clear()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityReference = WeakReference(binding.activity)
  }

  override fun onDetachedFromActivity() {
    activityReference.clear()
  }
}
