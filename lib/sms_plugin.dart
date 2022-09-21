
import 'sms_plugin_platform_interface.dart';

class SmsPlugin {
  Future<String?> getPlatformVersion() {
    return SmsPluginPlatform.instance.getPlatformVersion();
  }
  Future<void> sendSms(String phone, String message) {
    return SmsPluginPlatform.instance.sendSms(phone, message);
  }
}
