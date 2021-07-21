//  Copyright © 2019 650 Industries. All rights reserved.

#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesUpdate.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesLegacyRawManifest.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI40_0_0EXUpdatesLegacyUpdate : NSObject

+ (ABI40_0_0EXUpdatesUpdate *)updateWithLegacyManifest:(ABI40_0_0EXUpdatesLegacyRawManifest *)manifest
                                       config:(ABI40_0_0EXUpdatesConfig *)config
                                     database:(ABI40_0_0EXUpdatesDatabase *)database;

+ (NSURL *)bundledAssetBaseUrlWithManifest:(ABI40_0_0EXUpdatesLegacyRawManifest *)manifest config:(ABI40_0_0EXUpdatesConfig *)config;

@end

NS_ASSUME_NONNULL_END
