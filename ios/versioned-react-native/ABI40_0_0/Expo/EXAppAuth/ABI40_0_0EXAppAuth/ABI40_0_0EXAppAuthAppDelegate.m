// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI40_0_0EXAppAuth/ABI40_0_0EXAppAuthAppDelegate.h>
#import <ABI40_0_0UMCore/ABI40_0_0UMAppDelegateWrapper.h>
#import <ABI40_0_0EXAppAuth/ABI40_0_0EXAppAuthSessionsManager.h>
#import <ABI40_0_0UMCore/ABI40_0_0UMModuleRegistryProvider.h>

@implementation ABI40_0_0EXAppAuthAppDelegate

ABI40_0_0UM_REGISTER_SINGLETON_MODULE(ABI40_0_0EXAppAuthAppDelegate)

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  return [(ABI40_0_0EXAppAuthSessionsManager *)[ABI40_0_0UMModuleRegistryProvider getSingletonModuleForClass:ABI40_0_0EXAppAuthSessionsManager.class] application:app openURL:url options:options];
}

@end
