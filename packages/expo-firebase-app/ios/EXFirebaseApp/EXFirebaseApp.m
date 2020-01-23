// Copyright 2018-present 650 Industries. All rights reserved.

#import <UMCore/UMUtilities.h>
#import <EXFirebaseApp/EXFirebaseApp.h>
#import <EXFirebaseApp/EXFirebaseApp+FIROptions.h>
#import <UMConstantsInterface/UMConstantsInterface.h>

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
  FIROptions* firOptions = [self.class firOptionsWithGoogleServicesFile:self.googleServicesFile];
  [self.class updateFirAppWithOptions:firOptions name:nil completion:^(BOOL success) {
    // nop
    /*if (!success) {
      reject(@"ERR_FIREBASE_APP", @"Failed to initialize Firebase App", nil);
    }*/
  }];
  
  // In the Expo client, also initialize a Firebase app called "expo".
  // This app is used by the FaceDetector module when the default app is not available.
  NSString* appOwnership = _constants ? _constants.constants[@"appOwnership"] : nil;
  if ([@"expo" isEqualToString: appOwnership]) {
    FIROptions* expoFirOptions = [self.class firOptionsWithGoogleServicesFile:self.googleServicesFileFromBundle];
    [self.class updateFirAppWithOptions:expoFirOptions name:@"expo" completion:^(BOOL success) {
      // nop
      /*if (!success) {
        reject(@"ERR_FIREBASE_APP", @"Failed to initialize Firebase App", nil);
      }*/
    }];
  }
}

// TODO - Hein, created a Scoped class that overrides the googleServicesFile
// and loads from manifest when possible?
- (nullable NSDictionary*)googleServicesFile
{
  NSString* appOwnership = _constants ? _constants.constants[@"appOwnership"] : nil;
  if ([@"expo" isEqualToString: appOwnership]) {
    return self.googleServicesFileFromManifest;
  } else {
    return self.googleServicesFileFromBundle;
  }
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
  FIROptions* firOptions = [self.class firOptionsWithGoogleServicesFile:self.googleServicesFile];
  if (firOptions) {
    return @{
      @"DEFAULT_OPTIONS": [self.class firOptionsToJSON:firOptions]
    };
  } else {
    return @{};
  }
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
  FIRApp *app = name ? [FIRApp appNamed:name] : [FIRApp defaultApp];
  if (app != nil) return app;
  reject(@"ERR_FIREBASE_APP", @"The 'default' Firebase app is not initialized. Ensure your app has a valid GoogleService-Info.plist bundled and your project has react-native-unimodules installed. Optionally in the Expo client you can initialized the default app with initializeAppDangerously().", nil);
  return nil;
}

UM_EXPORT_METHOD_AS(initializeAppAsync,
                    initializeAppAsync:(nullable NSDictionary *)config
                    name:(nullable NSString*)name
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  [UMUtilities performSynchronouslyOnMainThread:^{
    FIROptions* firOptions = config
      ? [self.class firOptionsWithJSON:config]
      : [self.class firOptionsWithGoogleServicesFile:self.googleServicesFile];
    [self.class updateFirAppWithOptions:firOptions name:name completion:^(BOOL success) {
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
  resolve(app.name);
}

UM_EXPORT_METHOD_AS(getAppsAsync,
                    resolve:(UMPromiseResolveBlock)resolve
                    reject:(UMPromiseRejectBlock)reject)
{
  @try {
    NSArray<NSString*>* names = [[FIRApp allApps]allKeys];
    resolve(names ? names : @[]);
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
}

@end
