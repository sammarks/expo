// Copyright 2018-present 650 Industries. All rights reserved.

@protocol ABI40_0_0UMGyroscopeInterface

- (void)sensorModuleDidSubscribeForGyroscopeUpdates:(id)scopedSensorModule withHandler:(void (^)(NSDictionary *event))handlerBlock;
- (void)sensorModuleDidUnsubscribeForGyroscopeUpdates:(id)scopedSensorModule;
- (void)setGyroscopeUpdateInterval:(NSTimeInterval)intervalMs;
- (BOOL)isGyroAvailable;

@end
