//  Copyright © 2019 650 Industries. All rights reserved.

#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesEmbeddedAppLoader.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesLegacyUpdate.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesUpdate+Private.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesUtils.h>
#import <ABI40_0_0React/ABI40_0_0RCTConvert.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const ABI40_0_0EXUpdatesExpoAssetBaseUrl = @"https://d1wp6m56sqw74a.cloudfront.net/~assets/";
static NSString * const ABI40_0_0EXUpdatesExpoIoDomain = @"expo.io";
static NSString * const ABI40_0_0EXUpdatesExpHostDomain = @"exp.host";
static NSString * const ABI40_0_0EXUpdatesExpoTestDomain = @"expo.test";

@implementation ABI40_0_0EXUpdatesLegacyUpdate

+ (ABI40_0_0EXUpdatesUpdate *)updateWithLegacyManifest:(ABI40_0_0EXUpdatesLegacyRawManifest *)manifest
                                       config:(ABI40_0_0EXUpdatesConfig *)config
                                     database:(ABI40_0_0EXUpdatesDatabase *)database
{
  ABI40_0_0EXUpdatesUpdate *update = [[ABI40_0_0EXUpdatesUpdate alloc] initWithRawManifest:manifest
                                                                  config:config
                                                                database:database];

  if (manifest.isUsingDeveloperTool) {
    // XDL does not set a releaseId or commitTime for development manifests.
    // we do not need these so we just stub them out
    update.updateId = [NSUUID UUID];
    update.commitTime = [NSDate date];
  } else {
    NSString *updateId = manifest.releaseID;
    update.updateId = [[NSUUID alloc] initWithUUIDString:(NSString *)updateId];
    NSAssert(update.updateId, @"update ID should be a valid UUID");

    NSString *commitTimeString = manifest.commitTime;
    update.commitTime = [ABI40_0_0RCTConvert NSDate:commitTimeString];
  }

  if (manifest.isDevelopmentMode) {
    update.isDevelopmentMode = YES;
    update.status = ABI40_0_0EXUpdatesUpdateStatusDevelopment;
  } else {
    update.status = ABI40_0_0EXUpdatesUpdateStatusPending;
  }

  NSString *bundleUrlString = manifest.bundleUrl;
  NSArray *assets = manifest.bundledAssets ?: @[];
  
  if (manifest.runtimeVersion != nil) {
    update.runtimeVersion = manifest.runtimeVersion;
  } else {
    NSAssert(manifest.sdkVersion != nil, @"sdkVersion should not be null");
    update.runtimeVersion = manifest.sdkVersion;
  }

  NSURL *bundleUrl = [NSURL URLWithString:bundleUrlString];
  NSAssert(bundleUrl, @"bundleUrl should be a valid URL");

  NSMutableArray<ABI40_0_0EXUpdatesAsset *> *processedAssets = [NSMutableArray new];

  NSString *bundleKey = manifest.bundleKey ?: nil;
  ABI40_0_0EXUpdatesAsset *jsBundleAsset = [[ABI40_0_0EXUpdatesAsset alloc] initWithKey:bundleKey type:ABI40_0_0EXUpdatesEmbeddedBundleFileType];
  jsBundleAsset.url = bundleUrl;
  jsBundleAsset.isLaunchAsset = YES;
  jsBundleAsset.mainBundleFilename = ABI40_0_0EXUpdatesEmbeddedBundleFilename;
  [processedAssets addObject:jsBundleAsset];
  
  NSURL *bundledAssetBaseUrl = [[self class] bundledAssetBaseUrlWithManifest:manifest config:config];

  for (NSString *bundledAsset in assets) {
    NSAssert([bundledAsset isKindOfClass:[NSString class]], @"bundledAssets must be an array of strings");

    NSRange extensionStartRange = [bundledAsset rangeOfString:@"." options:NSBackwardsSearch];
    NSUInteger prefixLength = [@"asset_" length];
    NSString *filename;
    NSString *hash;
    NSString *type;
    if (extensionStartRange.location == NSNotFound) {
      filename = bundledAsset;
      hash = [bundledAsset substringFromIndex:prefixLength];
      type = @"";
    } else {
      filename = [bundledAsset substringToIndex:extensionStartRange.location];
      NSRange hashRange = NSMakeRange(prefixLength, extensionStartRange.location - prefixLength);
      hash = [bundledAsset substringWithRange:hashRange];
      type = [bundledAsset substringFromIndex:extensionStartRange.location + 1];
    }

    NSURL *url = [bundledAssetBaseUrl URLByAppendingPathComponent:hash];

    NSString *key = hash;
    ABI40_0_0EXUpdatesAsset *asset = [[ABI40_0_0EXUpdatesAsset alloc] initWithKey:key type:(NSString *)type];
    asset.url = url;
    asset.mainBundleFilename = filename;

    [processedAssets addObject:asset];
  }

  update.manifest = manifest.rawManifestJSON;
  update.keep = YES;
  update.bundleUrl = bundleUrl;
  update.assets = processedAssets;

  return update;
}

+ (NSURL *)bundledAssetBaseUrlWithManifest:(ABI40_0_0EXUpdatesLegacyRawManifest *)manifest config:(ABI40_0_0EXUpdatesConfig *)config
{
  NSURL *manifestUrl = config.updateUrl;
  NSString *host = manifestUrl.host;
  if (!host ||
      [host containsString:ABI40_0_0EXUpdatesExpoIoDomain] ||
      [host containsString:ABI40_0_0EXUpdatesExpHostDomain] ||
      [host containsString:ABI40_0_0EXUpdatesExpoTestDomain]) {
    return [NSURL URLWithString:ABI40_0_0EXUpdatesExpoAssetBaseUrl];
  } else {
    NSString *assetsPathOrUrl = manifest.assetUrlOverride ?: @"assets";
    // assetUrlOverride may be an absolute or relative URL
    // if relative, we should resolve with respect to the manifest URL
    return [NSURL URLWithString:assetsPathOrUrl relativeToURL:manifestUrl].absoluteURL.standardizedURL;
  }
}

@end

NS_ASSUME_NONNULL_END
