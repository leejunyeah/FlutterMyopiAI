package com.myopia.flutter_myopia_ai;

import android.os.Build;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    static MyFlutterEventPlugin endRecordPlugin;
    static MyFlutterEventPlugin lightPlugin;
    static MyFlutterEventPlugin timerPlugin;
    static MyFlutterEventPlugin lightWarningPlugin;

    static final String END_CHANNEL = "com.myopia.flutter_myopia_ai/end_record_plugin";
    static final String LIGHT_CHANNEL = "com.myopia.flutter_myopia_ai/light_plugin";
    static final String LIGHT_WARNING_CHANNEL = "com.myopia.flutter_myopia_ai/light_warning_plugin";
    static final String TIMER_CHANNEL = "com.myopia.flutter_myopia_ai/timer_plugin";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {//API>21,设置状态栏颜色透明
            getWindow().setStatusBarColor(0);
        }
        GeneratedPluginRegistrant.registerWith(this);
        // Flutter to Android
        registerRecordPlugin(this);
        registSettingsPlugin(this);

        // Android to Flutter
        endRecordPlugin = MyFlutterEventPlugin.registerEndRecordWith(END_CHANNEL,this);
        lightPlugin = MyFlutterEventPlugin.registerEndRecordWith(LIGHT_CHANNEL,this);
        timerPlugin = MyFlutterEventPlugin.registerEndRecordWith(TIMER_CHANNEL,this);
        lightWarningPlugin = MyFlutterEventPlugin.registerEndRecordWith(LIGHT_WARNING_CHANNEL,this);
    }

    private static void registerRecordPlugin(PluginRegistry registrar) {
        RecordAction.registerWith(registrar.registrarFor(RecordAction.CHANNEL));
    }

    private static void registSettingsPlugin(PluginRegistry registrar) {
        SettingsAction.registerWith(registrar.registrarFor(SettingsAction.CHANNEL));
    }

    public static void endRecordActivity() {
        if (endRecordPlugin.eventSink != null) {
            endRecordPlugin.eventSink.success("success");
        }
    }

    public static void lightUpdate(int value) {
        if (lightPlugin.eventSink != null) {
            lightPlugin.eventSink.success(value);
        }
    }

    public static void updateTimer(long counter) {
        if (timerPlugin.eventSink != null) {
            timerPlugin.eventSink.success(counter);
        }
    }

    public static void lightWarning() {
        if (lightWarningPlugin.eventSink != null) {
            lightWarningPlugin.eventSink.success("success");
        }
    }

    static class MyFlutterEventPlugin implements EventChannel.StreamHandler {

        EventChannel.EventSink eventSink;

        static MyFlutterEventPlugin registerEndRecordWith(String channel, PluginRegistry registry) {
            PluginRegistry.Registrar registrar = registry.registrarFor(channel);
            EventChannel eventChannel = new EventChannel(registrar.messenger(), channel);
            MyFlutterEventPlugin myFlutterEventPlugin = new MyFlutterEventPlugin();
            eventChannel.setStreamHandler(myFlutterEventPlugin);
            return myFlutterEventPlugin;
        }
        @Override
        public void onListen(Object o, EventChannel.EventSink eventSink) {
            this.eventSink = eventSink;
        }
        @Override
        public void onCancel(Object o) {
        }
    }
}
