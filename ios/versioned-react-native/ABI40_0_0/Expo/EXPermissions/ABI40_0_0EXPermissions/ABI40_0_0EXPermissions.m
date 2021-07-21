// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI40_0_0UMCore/ABI40_0_0UMUtilitiesInterface.h>
#import <ABI40_0_0UMCore/ABI40_0_0UMUtilities.h>

#import <ABI40_0_0EXPermissions/ABI40_0_0EXPermissions.h>

NSString * const ABI40_0_0EXStatusKey = @"status";
NSString * const ABI40_0_0EXExpiresKey = @"expires";
NSString * const ABI40_0_0EXGrantedKey = @"granted";
NSString * const ABI40_0_0EXCanAskAgain = @"canAskAgain";

NSString * const ABI40_0_0EXPermissionExpiresNever = @"never";

@interface ABI40_0_0EXPermissions ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<ABI40_0_0UMPermissionsRequester>> *requesters;
@property (nonatomic, strong) NSMapTable<Class, id<ABI40_0_0UMPermissionsRequester>> *requestersByClass;
@property (nonatomic, weak) ABI40_0_0UMModuleRegistry *moduleRegistry;

@end

@implementation ABI40_0_0EXPermissions

ABI40_0_0UM_EXPORT_MODULE(ExpoPermissions);

- (instancetype)init
{
  if (self = [super init]) {
    _requesters = [NSMutableDictionary<NSString *, id<ABI40_0_0UMPermissionsRequester>> new];
    _requestersByClass = [NSMapTable<Class, id<ABI40_0_0UMPermissionsRequester>> new];
  }
  return self;
}

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI40_0_0UMPermissionsInterface)];
}

- (void)registerRequesters:(NSArray<id<ABI40_0_0UMPermissionsRequester>> *)newRequesters {
  for (id<ABI40_0_0UMPermissionsRequester> requester in newRequesters) {
    [_requesters setObject:requester forKey:[[requester class] permissionType]];
    [_requestersByClass setObject:requester forKey:[requester class]];
  }
}

- (void)setModuleRegistry:(ABI40_0_0UMModuleRegistry *)moduleRegistry
{
  _moduleRegistry = moduleRegistry;
}

# pragma mark - Exported methods

ABI40_0_0UM_EXPORT_METHOD_AS(getAsync,
                    getPermissionWithType:(NSString *)permissionType
                    resolver:(ABI40_0_0UMPromiseResolveBlock)resolve
                    rejecter:(ABI40_0_0UMPromiseRejectBlock)reject)
{
  id<ABI40_0_0UMPermissionsRequester> requester = [self getPermissionRequesterForType:permissionType];
  if (requester == nil) {
    return reject(@"E_PERMISSIONS_UNKNOWN", [NSString stringWithFormat:@"Unrecognized permission: %@", permissionType], nil);
  }
  [self getPermissionUsingRequesterClass:[requester class]
                                 resolve:resolve
                                  reject:reject];
}

ABI40_0_0UM_EXPORT_METHOD_AS(askAsync,
                    askAsyncForPermission:(NSString *)permissionType
                    resolver:(ABI40_0_0UMPromiseResolveBlock)resolve
                    rejecter:(ABI40_0_0UMPromiseRejectBlock)reject)
{
  id<ABI40_0_0UMPermissionsRequester> requester = [self getPermissionRequesterForType:permissionType];
  if (requester == nil) {
    return reject(@"E_PERMISSIONS_UNKNOWN", [NSString stringWithFormat:@"Unrecognized permission: %@", permissionType], nil);
  }
  [self askForPermissionUsingRequesterClass:[requester class]
                                    resolve:resolve
                                     reject:reject];
}

# pragma mark - permission requsters / getters


- (void)getPermissionUsingRequesterClass:(Class)requesterClass
                                 resolve:(ABI40_0_0UMPromiseResolveBlock)resolve
                                  reject:(ABI40_0_0UMPromiseRejectBlock)reject
{
  NSDictionary *permission = [self getPermissionUsingRequesterClass:requesterClass];
  if (permission == nil) {
    return reject(@"E_PERMISSIONS_UNKNOWN", [NSString stringWithFormat:@"Unrecognized requester: %@", NSStringFromClass(requesterClass)], nil);
  }
  
  return resolve(permission);
}

- (NSDictionary *)getPermissionUsingRequesterClass:(Class)requesterClass
{
  return [self getPermissionUsingRequester:[self getPermissionRequesterForClass:requesterClass]];
}

- (NSDictionary *)getPermissionsForResource:(NSString *)type
{
  return [self getPermissionUsingRequester:[self getPermissionRequesterForType:type]];
}

- (NSDictionary *)getPermissionUsingRequester:(id<ABI40_0_0UMPermissionsRequester>)requester
{
  if (requester) {
    return [ABI40_0_0EXPermissions parsePermissionFromRequester:[requester getPermissions]];
  }
  return nil;
}

// shorthand method that checks both global and per-experience permission
- (BOOL)hasGrantedPermissionUsingRequesterClass:(Class)requesterClass
{
  NSDictionary *permissions = [self getPermissionUsingRequesterClass:requesterClass];
  if (!permissions) {
    ABI40_0_0UMLogWarn(@"Permission requester '%@' not found.", NSStringFromClass(requesterClass));
    return false;
  }
  
  return [permissions[ABI40_0_0EXStatusKey] isEqualToString:@"granted"];
}

- (void)askForPermissionUsingRequesterClass:(Class)requesterClass
                                    resolve:(ABI40_0_0UMPromiseResolveBlock)onResult
                                     reject:(ABI40_0_0UMPromiseRejectBlock)reject
{
  NSMutableDictionary *permission = [[self getPermissionUsingRequesterClass:requesterClass] mutableCopy];
  
  // permission type not found - reject immediately
  if (permission == nil) {
    return reject(@"E_PERMISSIONS_UNKNOWN", [NSString stringWithFormat:@"Unrecognized requester: %@", NSStringFromClass(requesterClass)], nil);
  }
  
  BOOL isGranted = [ABI40_0_0EXPermissions statusForPermission:permission] == ABI40_0_0UMPermissionStatusGranted;
  permission[@"granted"] = @(isGranted);
  
  if (isGranted) {
    return onResult(permission);
  }
  
  [self askForGlobalPermissionUsingRequesterClass:requesterClass withResolver:onResult withRejecter:reject];
}
   
- (void)askForGlobalPermissionUsingRequesterClass:(Class)requesterClass
                                     withResolver:(ABI40_0_0UMPromiseResolveBlock)resolver
                                     withRejecter:(ABI40_0_0UMPromiseRejectBlock)reject
{
  id<ABI40_0_0UMPermissionsRequester> requester = [self getPermissionRequesterForClass:requesterClass];
  if (requester == nil) {
    return reject(@"E_PERMISSIONS_UNSUPPORTED", @"Cannot find requester", nil);
  }
  
  void (^permissionParser)(NSDictionary *) = ^(NSDictionary * permission){
    resolver([ABI40_0_0EXPermissions parsePermissionFromRequester:permission]);
  };
  
  [requester requestPermissionsWithResolver:permissionParser rejecter:reject];
}


# pragma mark - helpers

+ (NSDictionary *)parsePermissionFromRequester:(NSDictionary *)permission
{
  NSMutableDictionary *parsedPermission = [permission mutableCopy];
  ABI40_0_0UMPermissionStatus status = (ABI40_0_0UMPermissionStatus)[permission[ABI40_0_0EXStatusKey] intValue];
  BOOL isGranted = status == ABI40_0_0UMPermissionStatusGranted;
  BOOL canAskAgain = status != ABI40_0_0UMPermissionStatusDenied;
  
  [parsedPermission setValue:[[self class] permissionStringForStatus:status] forKey:ABI40_0_0EXStatusKey];
  [parsedPermission setValue:ABI40_0_0EXPermissionExpiresNever forKey:ABI40_0_0EXExpiresKey];
  [parsedPermission setValue:@(isGranted) forKey:ABI40_0_0EXGrantedKey];
  [parsedPermission setValue:@(canAskAgain) forKey:ABI40_0_0EXCanAskAgain];
  return parsedPermission;
}

+ (NSString *)permissionStringForStatus:(ABI40_0_0UMPermissionStatus)status
{
  switch (status) {
    case ABI40_0_0UMPermissionStatusGranted:
      return @"granted";
    case ABI40_0_0UMPermissionStatusDenied:
      return @"denied";
    default:
      return @"undetermined";
  }
}

+ (ABI40_0_0UMPermissionStatus)statusForPermission:(NSDictionary *)permission
{
  NSString *status = permission[ABI40_0_0EXStatusKey];
  if ([status isEqualToString:@"granted"]) {
    return ABI40_0_0UMPermissionStatusGranted;
  } else if ([status isEqualToString:@"denied"]) {
    return ABI40_0_0UMPermissionStatusDenied;
  } else {
    return ABI40_0_0UMPermissionStatusUndetermined;
  }
}

- (id<ABI40_0_0UMPermissionsRequester>)getPermissionRequesterForType:(NSString *)type
{
  return _requesters[type];
}

- (id<ABI40_0_0UMPermissionsRequester>)getPermissionRequesterForClass:(Class)requesterClass
{
  return [_requestersByClass objectForKey:requesterClass];
}

@end

