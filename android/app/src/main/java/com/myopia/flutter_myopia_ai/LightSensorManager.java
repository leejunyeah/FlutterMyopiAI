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
import android.os.Looper;
import android.util.Log;

import com.myopia.flutter_myopia_ai.notification.NotificationCompat;


class LightSensorManager {

    private static final boolean DEBUG = BuildConfig.DEBUG;
    private static final String TAG = "LightSensor";

    /**
     * From wiki
     * https://en.wikipedia.org/wiki/Lux#cite_note-radfaq-3
     */
    private static final int CRITICAL_VALUE = 100;

    /**
     * The light sensor is very sensitive, we set a gap for it.
     */
    private static final int SENSOR_GAP = 10;

    private static LightSensorManager instance;
    private SensorManager mSensorManager;
    private LightSensorListener mLightSensorListener;
    private boolean mHasStarted = false;
    private boolean mCanNotifyLight = true;

    private NotificationManager mNotificationManager;

    private Handler mHandler = new Handler(Looper.getMainLooper());

    private LightSensorManager(Context context) {
        mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
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
                mLightSensorListener = new LightSensorListener(context);
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

    @TargetApi(3)
    private class LightSensorListener implements SensorEventListener {

        private float lux; // 光线强度
        private Context context;

        LightSensorListener(Context context) {
            this.context = context;
        }

        public void onAccuracyChanged(Sensor sensor, int accuracy) {
        }

        public void onSensorChanged(SensorEvent event) {
            if (event.sensor.getType() == Sensor.TYPE_LIGHT) {
                float tempValue = event.values[0];
                if (Math.abs(tempValue - lux) > SENSOR_GAP) {
                    lux = tempValue;
                    mHandler.post(() -> {
                        int lightValue = (int) mLightSensorListener.lux;
                        if (lightValue < CRITICAL_VALUE && mCanNotifyLight) {
                            if (mNotificationManager != null) {
                                Notification notification = NotificationCompat.getInstance(this.context).getNotification(this.context,
                                        null, this.context.getString(R.string.light_warning));
                                mNotificationManager.notify(NotificationCompat.NOTIFICATION_ACTIVITY_LIGHT_ID, notification);
                            }
                            MainActivity.lightWarning();
                        } else if (lightValue >= CRITICAL_VALUE) {
                            if (mNotificationManager != null) {
                                mNotificationManager.cancel(NotificationCompat.NOTIFICATION_ACTIVITY_LIGHT_ID);
                            }
                        }
                        MainActivity.lightUpdate(lightValue);
                    });
                    if (DEBUG) {
                        Log.d(TAG, "lux : " + lux);
                    }
                }
            }
        }

    }
}
