package com.myopia.flutter_myopia_ai;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;

import com.myopia.flutter_myopia_ai.notification.NotificationCompat;

import java.util.Timer;
import java.util.TimerTask;

public class RecordingService extends Service {

    public static final String ACTION_START = "myopia.start.record.action";
    public static final String ACTION_STOP = "myopia.stop.record.action";
    public static final String ACTION_END = "myopia.end.record.action";
    public static final String ACTION_END_NOTIFICATION = "myopia.end.notification.record.action";
    public static final String ACTION_CONTINUE = "myopia.continue.record.action";

    private TimerTask mTimerTask;
    private Timer mTimer;

    private Handler mHandler = new Handler();

    private long mCounter;
    private String mTitle;
    private NotificationManager mNotificationManager;

    @Override
    public void onCreate() {
        super.onCreate();
        mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (ACTION_START.equals(intent.getAction())) {
            mTitle = intent.getStringExtra("title");
            startTimer();
            Notification notification = NotificationCompat.getInstance(this).
                    getForegroundNotification(this, mTitle, "00:00:00");
            startForeground(NotificationCompat.NOTIFICATION_ACTIVITY_COUNTER_ID, notification);
            LightSensorManager.getInstance(this).start(this);
        } else if (ACTION_STOP.equals(intent.getAction())) {
            stopTimer();
        } else if (ACTION_END.equals(intent.getAction())) {
            endTimer();
            LightSensorManager.getInstance(this).stop();
            stopSelf();
        } else if (ACTION_END_NOTIFICATION.equals(intent.getAction())) {
            endTimer();
            LightSensorManager.getInstance(this).stop();
            MainActivity.endRecordActivity();
            stopSelf();
        } else if (ACTION_CONTINUE.equals(intent.getAction())) {
            continueTimer();
        }
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        endTimer();
        LightSensorManager.getInstance(this).stop();
    }

    private void endTimer() {
        if (mTimerTask != null) {
            mTimerTask.cancel();
            mTimerTask = null;
        }
        if (mTimer != null) {
            mTimer.cancel();
            mTimer = null;
        }
        mCounter = 0;
    }

    private void startTimer() {
        endTimer();
        mTimer = new Timer();
        mTimerTask = new TimerTask() {

            @Override
            public void run() {
                mCounter++;
                mHandler.post(() -> MainActivity.updateTimer(mCounter));
                Notification notification = NotificationCompat.getInstance(RecordingService.this)
                        .getForegroundNotification(RecordingService.this, mTitle, parserTimer(mCounter));
                mNotificationManager.notify(NotificationCompat.NOTIFICATION_ACTIVITY_COUNTER_ID, notification);
            }
        };
        mTimer.scheduleAtFixedRate(mTimerTask, 0, 1000);
    }

    private void stopTimer() {
        if (mTimerTask != null) {
            mTimerTask.cancel();
            mTimerTask = null;
        }
        if (mTimer != null) {
            mTimer.cancel();
            mTimer = null;
        }
    }

    private void continueTimer() {
        stopTimer();
        mTimer = new Timer();
        mTimerTask = new TimerTask() {

            @Override
            public void run() {
                mCounter++;
                mHandler.post(() -> MainActivity.updateTimer(mCounter));
                Notification notification = NotificationCompat.getInstance(RecordingService.this)
                        .getForegroundNotification(RecordingService.this, mTitle, parserTimer(mCounter));
                mNotificationManager.notify(NotificationCompat.NOTIFICATION_ACTIVITY_COUNTER_ID, notification);
            }
        };
        mTimer.scheduleAtFixedRate(mTimerTask, 0, 1000);
    }

    private String parserTimer(long counter) {
        int hour = (int) (counter / (60 * 60));
        int min = (int) ((counter - hour * (60 * 60)) / 60);
        int sec = (int) (counter - hour * (60 * 60) - min * 60);
        return (hour < 10 ? ("0" + hour) : hour) +
                ":" + (min < 10 ? ("0" + min) : min) +
                ":" + (sec < 10 ? ("0" + sec) : sec);
    }

}
