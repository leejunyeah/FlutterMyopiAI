package com.myopia.flutter_myopia_ai;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Handler;
import android.os.Message;
import android.os.SystemClock;
import android.util.Log;

import com.myopia.flutter_myopia_ai.notification.NotificationCompat;

import java.lang.ref.WeakReference;


class LightSensorManager {

    private static final boolean DEBUG = BuildConfig.DEBUG;
    private static final String TAG = "LightSensor";

    /**
     * From wiki
     * https://en.wikipedia.org/wiki/Lux#cite_note-radfaq-3
     */
    private static final int CRITICAL_VALUE = 20;

    /**
     * The light sensor is very sensitive, we set a gap for it.
     */
    private static final int SENSOR_GAP = 10;

    private static final int MSG_LIGHT_UPDATE = 0x01;

    private static final int LIGHT_UPDATE_TIMEOUT = 10 * 1000;
    private static final int LIGHT_NOTIFY_TIMEOUT = 60 * 1000;

    private static LightSensorManager instance;
    private SensorManager mSensorManager;
    private LightSensorListener mLightSensorListener;
    private boolean mHasStarted = false;
    private boolean mCanNotifyLight = true;

    private long mCriticalStartTime = -1;

    private MHandler mHandler;


    private NotificationManager mNotificationManager;

    private LightSensorManager(Context context) {
        mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        mHandler = new MHandler(this, context);
    }

    static LightSensorManager getInstance(Context context) {
        if (instance == null) {
            instance = new LightSensorManager(context);
        }
        return instance;
    }

    @TargetApi(3)
    void start(Context context) {
        Log.d(TAG, "start");
        if (mHasStarted) {
            return;
        }
        mSensorManager = (SensorManager) context.getApplicationContext().getSystemService(Context.SENSOR_SERVICE);
        if (mSensorManager != null) {
            mHasStarted = true;
            Sensor lightSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_LIGHT); // 获取光线传感器
            if (lightSensor != null) { // 光线传感器存在时
                mLightSensorListener = new LightSensorListener();
                mSensorManager.registerListener(mLightSensorListener, lightSensor,
                        SensorManager.SENSOR_DELAY_NORMAL); // 注册事件监听
            } else {
                Log.e(TAG, "lightSensor is null");
            }
        }
    }

    boolean isLightSensorValid(Context context) {
        SensorManager sensorManager =
                (SensorManager) context.getApplicationContext().getSystemService(Context.SENSOR_SERVICE);
        if (sensorManager == null) return false;
        Sensor lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
        if (lightSensor == null) return false;
        return true;
    }

    void setCanNotifyLight(boolean canNotifyLight) {
        mCanNotifyLight = canNotifyLight;
    }

    @TargetApi(3)
    void stop() {
        if (mHandler != null) {
            mHandler.removeCallbacksAndMessages(null);
        }
        if (!mHasStarted || mSensorManager == null) {
            return;
        }
        mHasStarted = false;
        mSensorManager.unregisterListener(mLightSensorListener);
    }

    /**
     * 获取光线强度
     */
    float getLux() {
        if (mLightSensorListener != null) {
            return mLightSensorListener.lux;
        }
        return 0f; // 默认返回0，表示设备无光线传感器或者为调用start()方法
    }

    private static class MHandler extends Handler {

        private WeakReference<LightSensorManager> weakReference;
        private Context context;

        MHandler(LightSensorManager obj, Context context) {
            weakReference = new WeakReference<>(obj);
            this.context = context;
        }

        @Override
        public void handleMessage(Message msg) {
            if (weakReference == null) return;
            LightSensorManager _this = weakReference.get();
            if (_this == null) return;
            int lightValue = (int) _this.mLightSensorListener.lux;
            if (MSG_LIGHT_UPDATE == msg.what) {
                MainActivity.lightUpdate(lightValue);
                if (lightValue < CRITICAL_VALUE && _this.mCanNotifyLight) {
                    if (_this.mCriticalStartTime <= 0) {
                        _this.mCriticalStartTime = SystemClock.elapsedRealtime();
                    } else {
                        long current = SystemClock.elapsedRealtime();
                        if (current - _this.mCriticalStartTime > LIGHT_NOTIFY_TIMEOUT) {
                            _this.mCriticalStartTime = current;
                            if (_this.mNotificationManager != null) {
                                Notification notification =
                                        NotificationCompat.getInstance(this.context).getNotification(this.context,
                                        null, this.context.getString(R.string.light_warning));
                                _this.mNotificationManager.notify(NotificationCompat.NOTIFICATION_ACTIVITY_LIGHT_ID, notification);
                            }
                            MainActivity.lightWarning();
                        }
                    }
                } else if (lightValue >= CRITICAL_VALUE) {
                    _this.mCriticalStartTime = -1;
                    if (_this.mNotificationManager != null) {
                        _this.mNotificationManager.cancel(NotificationCompat.NOTIFICATION_ACTIVITY_LIGHT_ID);
                    }
                }
                sendEmptyMessageDelayed(MSG_LIGHT_UPDATE, LIGHT_UPDATE_TIMEOUT);
            }
        }
    }

    @TargetApi(3)
    private class LightSensorListener implements SensorEventListener {

        private float lux; // 光线强度

        LightSensorListener() {
        }

        public void onAccuracyChanged(Sensor sensor, int accuracy) {
        }

        public void onSensorChanged(SensorEvent event) {
            if (event.sensor.getType() == Sensor.TYPE_LIGHT) {
                float tempValue = event.values[0];
                if (Math.abs(tempValue - lux) > SENSOR_GAP) {
                    lux = tempValue;
                    if (mHandler != null) {
                        if (mHandler.hasMessages(MSG_LIGHT_UPDATE)) {
                            mHandler.removeMessages(MSG_LIGHT_UPDATE);
                        }
                        mHandler.sendEmptyMessage(MSG_LIGHT_UPDATE);
                    }
                    if (DEBUG) {
                        Log.d(TAG, "lux : " + lux);
                    }
                }
            }
        }

    }
}
