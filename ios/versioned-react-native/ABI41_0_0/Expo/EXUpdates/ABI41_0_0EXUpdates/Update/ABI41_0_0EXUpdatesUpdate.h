//  Copyright © 2019 650 Industries. All rights reserved.

#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesAsset.h>
#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesConfig.h>
#import <ABI41_0_0EXUpdates/ABI41_0_0EXUpdatesRawManifest.h>

@class ABI41_0_0EXUpdatesDatabase;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ABI41_0_0EXUpdatesUpdateStatus) {
  ABI41_0_0EXUpdatesUpdateStatusFailed = 0,
  ABI41_0_0EXUpdatesUpdateStatusReady = 1,
  ABI41_0_0EXUpdatesUpdateStatusLaunchable = 2,
  ABI41_0_0EXUpdatesUpdateStatusPending = 3,
  ABI41_0_0EXUpdatesUpdateStatusUnused = 4,
  ABI41_0_0EXUpdatesUpdateStatusEmbedded = 5,
  ABI41_0_0EXUpdatesUpdateStatusDevelopment = 6
};

@interface ABI41_0_0EXUpdatesUpdate : NSObject

@property (nonatomic, strong, readonly) NSUUID *updateId;
@property (nonatomic, strong, readonly) NSString *scopeKey;
@property (nonatomic, strong, readonly) NSDate *commitTime;
@property (nonatomic, strong, readonly) NSString *runtimeVersion;
@property (nonatomic, strong, readonly, nullable) NSDictionary *manifest;
@property (nonatomic, assign, readonly) BOOL keep;
@property (nonatomic, strong, readonly) NSArray<ABI41_0_0EXUpdatesAsset *> *assets;
@property (nonatomic, assign, readonly) BOOL isDevelopmentMode;

@property (nonatomic, strong, readonly, nullable) NSDictionary *serverDefinedHeaders;
@property (nonatomic, strong, readonly, nullable) NSDictionary *manifestFilters;

@property (nonatomic, strong, readonly) ABI41_0_0EXUpdatesRawManifest *rawManifest;

@property (nonatomic, assign) ABI41_0_0EXUpdatesUpdateStatus status;
@property (nonatomic, strong) NSDate *lastAccessed;

+ (instancetype)updateWithId:(NSUUID *)updateId
                    scopeKey:(NSString *)scopeKey
                  commitTime:(NSDate *)commitTime
              runtimeVersion:(NSString *)runtimeVersion
                    manifest:(nullable NSDictionary *)manifest
                      status:(ABI41_0_0EXUpdatesUpdateStatus)status
                        keep:(BOOL)keep
                      config:(ABI41_0_0EXUpdatesConfig *)config
                    database:(ABI41_0_0EXUpdatesDatabase *)database;

+ (instancetype)updateWithManifest:(NSDictionary *)manifest
                          response:(nullable NSURLResponse *)response
                            config:(ABI41_0_0EXUpdatesConfig *)config
                          database:(ABI41_0_0EXUpdatesDatabase *)database
                             error:(NSError **)error;

+ (instancetype)updateWithEmbeddedManifest:(NSDictionary *)manifest
                                    config:(ABI41_0_0EXUpdatesConfig *)config
                                  database:(nullable ABI41_0_0EXUpdatesDatabase *)database;

+ (ABI41_0_0EXUpdatesRawManifest *)rawManifestForJSON:(NSDictionary *)manifestJSON;

@end

NS_ASSUME_NONNULL_END
