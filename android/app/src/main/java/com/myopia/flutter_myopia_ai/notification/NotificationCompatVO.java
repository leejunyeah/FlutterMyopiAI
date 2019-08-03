package com.myopia.flutter_myopia_ai.notification;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

import com.myopia.flutter_myopia_ai.MainActivity;
import com.myopia.flutter_myopia_ai.R;
import com.myopia.flutter_myopia_ai.RecordingService;

@TargetApi(26)
public class NotificationCompatVO extends NotificationCompat {


    NotificationCompatVO(Context context) {
        super(context);
        NotificationChannels.createAllNotificationChannels(context);
    }

    @Override
    public Notification getForegroundNotification(Context context, String text, String timer) {
        Intent mainIntent = new Intent();
        mainIntent.setClass(context, MainActivity.class);

        PendingIntent mainPending = PendingIntent.getActivity(context, 0,
                mainIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (notificationManager == null) return null;

        Notification.Builder builder = new Notification.Builder(context);

        PendingIntent endIntent = PendingIntent.getService(context, 0,
                startRecordService(context, RecordingService.ACTION_END_NOTIFICATION), PendingIntent.FLAG_UPDATE_CURRENT);

        builder.setSmallIcon(R.drawable.ic_app_icon);

        builder.setContentIntent(mainPending);

        builder.setContentTitle(text + " " +context.getString(R.string.activity));

        builder.setContentText(timer);

        builder.setChannelId(NotificationChannels.DEFAULT);

        Notification.Action endActionBuilder = new Notification.Action.Builder(
                null, context.getString(R.string.end), endIntent)
                .build();
        builder.addAction(endActionBuilder);

        return builder.build();
    }

    @Override
    public Notification getNotification(Context context, String title, String text) {
        Intent mainIntent = new Intent();
        mainIntent.setClass(context, MainActivity.class);

        PendingIntent mainPending = PendingIntent.getActivity(context, 0,
                mainIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (notificationManager == null) return null;

        Notification.Builder builder = new Notification.Builder(context);

        builder.setSmallIcon(R.drawable.ic_app_icon);

        builder.setContentIntent(mainPending);

        if (title != null) {
            builder.setContentTitle(title);
        }

        builder.setContentText(text);

        builder.setChannelId(NotificationChannels.DEFAULT);

        builder.setAutoCancel(true);

        return builder.build();
    }
}
