package com.myopia.flutter_myopia_ai;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class SettingsAction implements MethodChannel.MethodCallHandler {

    static String CHANNEL = "com.myopia.flutter_myopia_ai/settings";
    private static MethodChannel channel;

    private Activity activity;

    private SettingsAction(Activity activity) {
        this.activity = activity;
    }

    static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        SettingsAction instance = new SettingsAction(registrar.activity());
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "rateUs":
                gotoPlayStore();
                result.success("success");
                break;
            case "checkUpdate":
                gotoPlayStore();
                result.success("success");
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void gotoPlayStore() {
        String uriString = "https://play.google.com/store/apps/details?id=" + activity.getPackageName();
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(uriString));
        intent.setPackage("com.android.vending");
        activity.startActivity(intent);
    }
}
