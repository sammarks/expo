package abi41_0_0.org.unimodules.interfaces.sensors;

import android.hardware.SensorEventListener2;

public interface SensorService {
  SensorServiceSubscription createSubscriptionForListener(SensorEventListener2 sensorEventListener);
}
