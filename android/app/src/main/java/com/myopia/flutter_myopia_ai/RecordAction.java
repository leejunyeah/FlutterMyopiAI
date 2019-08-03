package com.myopia.flutter_myopia_ai;

import android.app.Activity;
import android.content.Intent;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class RecordAction implements MethodChannel.MethodCallHandler {

    static String CHANNEL = "com.myopia.flutter_myopia_ai/record";
    private static MethodChannel channel;

    private Activity activity;

    private RecordAction(Activity activity) {
        this.activity = activity;
    }

    static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        RecordAction instance = new RecordAction(registrar.activity());
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "startRecord":
                String title = methodCall.argument("title");
                Intent service = new Intent(RecordingService.ACTION_START);
                service.setClass(activity, RecordingService.class);
                service.putExtra("title", title);
                activity.startService(service);
                result.success("success");
                break;
            case "stopRecord":
                startRecordService(RecordingService.ACTION_STOP);
                result.success("success");
                break;
            case "continueRecord":
                startRecordService(RecordingService.ACTION_CONTINUE);
                result.success("success");
                break;
            case "endRecord":
                startRecordService(RecordingService.ACTION_END);
                result.success("success");
                break;
            case "hasLightSensor":
                result.success(LightSensorManager.getInstance(this.activity).isLightSensorValid(this.activity));
                break;
            case "setCanNotifyLight":
                boolean canNotify = "true".equals(methodCall.argument("canNotifyLight"));
                LightSensorManager.getInstance(this.activity).setCanNotifyLight(canNotify);
                result.success("success");
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void startRecordService(String action) {
        Intent service = new Intent(action);
        service.setClass(activity, RecordingService.class);
        activity.startService(service);
    }
}
