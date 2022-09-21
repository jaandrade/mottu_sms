package br.com.mottu.sms_plugin;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.telephony.SmsManager;
import io.flutter.Log;

public class Sms {

    public static final String TAG = "SmsPlugin";

    public static void sendSms(Context context, String phone, String message) {

        try {

            SmsManager smsManager = SmsManager.getDefault();

            PendingIntent pIntent = PendingIntent.getBroadcast(context, 0, new Intent(), 0);

            smsManager.sendTextMessage(phone, null, message, pIntent, null );

            Log.d(TAG, "Successes send SMS to ["+phone+"] message ["+message+"]");

        } catch(Exception e) {
            Log.e(TAG, "Error send SMS to ["+phone+"]");

            e.printStackTrace();
        }
    }
}
