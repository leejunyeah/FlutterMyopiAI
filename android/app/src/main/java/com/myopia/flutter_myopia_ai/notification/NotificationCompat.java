package com.myopia.flutter_myopia_ai.notification;

import android.app.Notification;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import com.myopia.flutter_myopia_ai.RecordingService;

public abstract class NotificationCompat {

    public static final int NOTIFICATION_ACTIVITY_COUNTER_ID = 0x01;
    public static final int NOTIFICATION_ACTIVITY_LIGHT_ID = 0x02;

    private static NotificationCompat sInstance;

    NotificationCompat(Context context) {

    }

    public static NotificationCompat getInstance(Context context) {
        if (sInstance == null) {
            synchronized (NotificationCompat.class) {
                if (Build.VERSION.SDK_INT >= 26) {
                    sInstance = new NotificationCompatVO(context);
                } else {
                    sInstance = new NotificationCompatV(context);
                }
            }
        }
        return sInstance;
    }

    public abstract Notification getForegroundNotification(Context context, String text, String timer);

    public abstract Notification getNotification(Context context, String title, String text);

    Intent startRecordService(Context context, String action) {
        Intent service = new Intent(action);
        service.setClass(context, RecordingService.class);
        return service;
    }
}
