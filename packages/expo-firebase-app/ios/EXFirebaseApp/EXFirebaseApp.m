// Copyright 2018-present 650 Industries. All rights reserved.

#import <UMCore/UMUtilities.h>
#import <EXFirebaseApp/EXFirebaseApp.h>
#import <EXFirebaseApp/EXFirebaseApp+FIROptions.h>
#import <UMConstantsInterface/UMConstantsInterface.h>

#define DEFAULT_APP_NAME @"__FIRAPP_DEFAULT"

@interface EXFirebaseApp ()

@property (nonatomic, weak) UMModuleRegistry *moduleRegistry;
@property (nonatomic, weak) id<UMConstantsInterface> constants;

@end

@implementation EXFirebaseApp

UM_EXPORT_MODULE(ExpoFirebaseApp);

- (void)setModuleRegistry:(UMModuleRegistry *)moduleRegistry
{
  _moduleRegistry = moduleRegistry;
  _constants = [moduleRegistry getModuleImplementingProtocol:@protocol(UMConstantsInterface)];

  NSString* name = [self getDefaultAppName];
  FIROptions* options = [self getDefaultAppOptions];
  
  // Delete all previously created apps
  // TODO
  
  // Initialize app
  if (name && options) {
    [self.class updateAppWithOptions:options name:name completion:^(BOOL success) {
      // nop
      /*if (!success) {
        reject(@"ERR_FIREBASE_APP", @"Failed to initialize Firebase App", nil);
      }*/
    }];
  }
  
  // In the Expo client, also initialize a Firebase app called "expo".
  // This app is used by the FaceDetector module when the default app is not available.
  /*NSString* appOwnership = _constants ? _constants.constants[@"appOwnership"] : nil;
  if ([@"expo" isEqualToString: appOwnership]) {
    FIROptions* expoFirOptions = [self.class firOptionsWithGoogleServicesFile:self.googleServicesFileFromBundle];
    [self.class updateFirAppWithOptions:expoFirOptions name:@"expo" completion:^(BOOL success) {
    }];
  }*/
}

- (nullable NSDictionary*)googleServicesFileFromBundle
{
  NSString *path = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
  if (!path) return nil;
  NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:path];
  return plist;
}

- (nullable NSDictionary*)googleServicesFileFromManifest
{
  // load GoogleService-Info.plist from manifest
  if (_constants == nil) return nil;
  NSDictionary* manifest = _constants.constants[@"manifest"];
  NSDictionary* ios = manifest ? manifest[@"ios"] : nil;
  NSString* googleServicesFile = ios ? ios[@"googleServicesFile"] : nil;
  if (!googleServicesFile) return nil;
  NSData *data = [[NSData alloc] initWithBase64EncodedString:googleServicesFile options:0];
  NSError* error;
  NSDictionary* plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&error];
  return plist;
}

- (NSDictionary *)constantsToExport
{
  NSMutableDictionary* constants = [NSMutableDictionary dictionaryWithDictionary:@{
    @"DEFAULT_NAME": [self getDefaultAppName]
  }];
  
  FIROptions* options = [self getDefaultAppOptions];
  if (options) {
    [constants setObject:[self.class firOptionsToJSON:options] forKey:@"DEFAULT_OPTIONS"];
  }
  
  return constants;
}

- (void)reject:(UMPromiseRejectBlock)reject withException:(NSException *)exception {
  NSError *error = [NSError errorWithDomain:@"ERR_FIREBASE_APP" code:4815162342 userInfo:@{
        @"message": exception.reason,
        @"code": exception.name,
    }];
  reject(exception.name, exception.reason, error);
}

- (nullable FIRApp *)getAppOrReject:(NSString*)name reject:(UMPromiseRejectBlock)reject
{
  if (name == nil) {
    name = [self getDefaultAppName];
  }
  
  if (![self isAppAccessible:name]) {
    reject(@"ERR_FIREBASE_APP", @"The Firebase app is not accessible.", nil);
    return nil;
  }
  
  FIRApp *app = [FIRApp appNamed:name];
  if (app != nil) return app;
  reject(@"ERR_FIREBASE_APP", @"The 'default' Firebase app is not initialized. Ensure your app has a valid GoogleService-Info.plist bundled and your project has react-native-unimodules installed.", nil);
  return nil;
}

- (nonnull NSString*) getDefaultAppName
{
  NSString* appOwnership = _constants ? _constants.constants[@"appOwnership"] : nil;
  if ([@"expo" isEqualToString: appOwnership]) {
    // TODO
    return @"__sandbox.todoExperienceId";
  }
  return DEFAULT_APP_NAME;
}

- (nullable FIROptions*) getDefaultAppOptions
{
  NSString* appOwnership = _constants ? _constants.constants[@"appOwnership"] : nil;
  NSDictionary* googleServicesFile = [@"expo" isEqualToString: appOwnership]
    ? self.googleServicesFileFromManifest
    : self.googleServicesFileFromBundle;
  return [self.class firOptionsWithGoogleServicesFile:googleServicesFile];
}

- (BOOL) isAppAccessible:(nonnull NSString*)name
{
  // Deny access to the Default app on sandboxed environments
  NSString* appOwnership = _constants ? _constants.constants[@"appOwnership"] : nil;
  if ([@"expo" isEqualToString: appOwnership]) {
    if ([name isEqualToString:DEFAULT_APP_NAME]) {
      return NO;
    }
  }
  return YES;
}

UM_EXPORT_METHOD_AS(initializeAppAsync,
                    initializeAppAsync:(nullable NSDictionary *)json
                    name:(nullable NSString*)name
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  if (name && !json) {
    reject(@"ERR_FIREBASE_APP", @"No options provided for custom app", nil);
    return;
  }
  if (!name) {
    name = [self getDefaultAppName];
    if (!name) {
      reject(@"ERR_FIREBASE_APP", @"No `GoogleService-Info.plist` configured", nil);
      return;
    }
  }
  if ([self isAppAccessible:name]) {
    reject(@"ERR_FIREBASE_APP", @"Access to the Firebase App is forbidden", nil);
    return;
  }
  
  FIROptions* options = json
    ? [self.class firOptionsWithJSON:json]
    : [self getDefaultAppOptions];
  
  [UMUtilities performSynchronouslyOnMainThread:^{
    [self.class updateAppWithOptions:options name:name completion:^(BOOL success) {
      if (success) {
        resolve([NSNull null]);
      } else {
        reject(@"ERR_FIREBASE_APP", @"Failed to initialize Firebase App", nil);
      }
    }];
  }];
}

UM_EXPORT_METHOD_AS(getAppAsync,
                    getAppAsync:(NSString*)name
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  FIRApp* app = [self getAppOrReject:name reject:reject];
  if (!app) return;
  resolve(@{
    @"name": app.name,
    @"options": [self.class firOptionsToJSON:app.options]
  });
}

UM_EXPORT_METHOD_AS(getAppsAsync,
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  @try {
    NSDictionary<NSString *,FIRApp *>* apps = [FIRApp allApps];
    NSArray<NSString*>* names = [apps allKeys];
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:names.count];
    for (int i = 0; i < names.count; i++) {
      NSString* name = names[i];
      if ([self isAppAccessible:name]) {
        FIRApp* app = apps[name];
        [results addObject:@{
          @"name": name,
          @"options": [self.class firOptionsToJSON:app.options]
        }];
      }
    }
    resolve(results);
  } @catch (NSException *exception) {
    [self reject:reject withException:exception];
  }
}

UM_EXPORT_METHOD_AS(deleteAppAsync,
                    deleteAppAsync:(NSString*)name
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  FIRApp* app = [self getAppOrReject:name reject:reject];
  if (!app) return;
  [app deleteApp:^(BOOL success) {
    if (success) {
      resolve([NSNull null]);
    } else {
      reject(@"ERR_FIREBASE_APP", @"Failed to delete Firebase App", nil);
    }
  }];
}

/*
UM_EXPORT_METHOD_AS(getAppOptionsAsync,
                    getAppOptionsAsync:(NSString*)name
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  FIRApp* app = [self getAppOrReject:name reject:reject];
  if (!app) return;
  @try {
    resolve([self.class firOptionsToJSON:app.options]);
  } @catch (NSException *exception) {
    [self reject:reject withException:exception];
  }
}*/

@end
