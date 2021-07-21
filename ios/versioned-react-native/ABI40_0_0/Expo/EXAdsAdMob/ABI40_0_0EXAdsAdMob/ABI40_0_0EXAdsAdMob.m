// Copyright 2019-present 650 Industries. All rights reserved.

#import <ABI40_0_0EXAdsAdMob/ABI40_0_0EXAdsAdMob.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@implementation ABI40_0_0EXAdsAdMob

ABI40_0_0UM_EXPORT_MODULE(ExpoAdsAdMob);

ABI40_0_0UM_EXPORT_METHOD_AS(setTestDeviceIDAsync,
                    setTestDeviceID:(NSString *)testDeviceID
                    resolver:(ABI40_0_0UMPromiseResolveBlock)resolve
                    rejecter:(ABI40_0_0UMPromiseRejectBlock)reject)
{
  NSArray<NSString *>* testDeviceIdentifiers = nil;
  if (testDeviceID && ![testDeviceID isEqualToString:@""]) {
    if ([testDeviceID isEqualToString:@"EMULATOR"]) {
      testDeviceIdentifiers = @[kGADSimulatorID];
    } else {
      testDeviceIdentifiers = @[testDeviceID];
    }
  }
  GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = testDeviceIdentifiers;
  resolve(nil);
}

@end
