// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI40_0_0UMPermissionsInterface/ABI40_0_0UMPermissionsMethodsDelegate.h>

@implementation ABI40_0_0UMPermissionsMethodsDelegate

+ (void)askForPermissionWithPermissionsManager:(id<ABI40_0_0UMPermissionsInterface>)permissionsManager
                                 withRequester:(Class)requesterClass
                                       resolve:(ABI40_0_0UMPromiseResolveBlock)resolve
                                        reject:(ABI40_0_0UMPromiseRejectBlock)reject
{
  if (!permissionsManager) {
    return reject(@"E_NO_PERMISSIONS", @"Permissions module not found. Are you sure that Expo modules are properly linked?", nil);
  }
  [permissionsManager askForPermissionUsingRequesterClass:requesterClass
                                                  resolve:resolve
                                                   reject:reject];
}

+ (void)getPermissionWithPermissionsManager:(id<ABI40_0_0UMPermissionsInterface>)permissionsManager
                              withRequester:(Class)requesterClass
                                    resolve:(ABI40_0_0UMPromiseResolveBlock)resolve
                                     reject:(ABI40_0_0UMPromiseRejectBlock)reject
{
  if (!permissionsManager) {
    return reject(@"E_NO_PERMISSIONS", @"Permissions module not found. Are you sure that Expo modules are properly linked?", nil);
  }
  [permissionsManager getPermissionUsingRequesterClass:requesterClass
                                               resolve:resolve
                                                reject:reject];
}

+ (void)registerRequesters:(NSArray<id<ABI40_0_0UMPermissionsRequester>> *)newRequesters
    withPermissionsManager:(id<ABI40_0_0UMPermissionsInterface>)permissionsManager
{
  if (permissionsManager) {
    [permissionsManager registerRequesters:newRequesters];
  }
}

@end
